//
//  TrendViewModel.swift
//  BitLery
//
//  Created by 정인선 on 3/8/25.
//

import Foundation
import RxCocoa
import RxSwift

final class TrendViewModel: BaseViewModel {
    private let monitor = NetworkMonitorService.shared
    var disposeBag = DisposeBag()
    private var isFetched = false
    private var isRunning = true
    private let showIndicatorTrigger = BehaviorRelay(value: true)
    private let updateTimeText = BehaviorRelay(value: "")
    private let TrendCoinData = BehaviorRelay(value: [TrendCoin]())
    private let trendNFTData = BehaviorRelay(value: [TrendNFT]())
    private let dialogTrigger = PublishRelay<String?>()
    private let monitorDialogTrigger = PublishRelay<Void?>()
    private let toastTrigger = PublishRelay<Void>()

    private var isDismissDialog = true
    private var lastUpdateTime: Date?  // 마지막 업데이트 시간 추적
    private let updateInterval: TimeInterval = 600  // 10분 (600초)
    
    struct Input {
        let viewDidLoadTrigger: PublishRelay<Void>
        let isTimerRunning: BehaviorRelay<Bool>
        let returnButtonTapped: ControlEvent<Void>
        let searchText: ControlProperty<String?>
        let selectedCoin: ControlEvent<TrendCoin>
        let networkRetryTrigger: PublishRelay<Void>
        let dismissDialogTrigger: PublishRelay<Void>
    }
    struct Output {
        let showIndicatorTrigger: Driver<Bool>
        let updateTimeText: Driver<String>
        let TrendCoinData: Driver<[TrendCoin]>
        let trendNFTData: Driver<[TrendNFT]>
        let dialogTrigger: Driver<String?>
        let pushSearchTrigger: PublishRelay<String>
        let pushDetailTrigger: PublishRelay<CoinBasicInfo>
        let searchBarClearTigger: PublishRelay<Void>
        let monitorDialogTrigger: Driver<Void?>
        let toastTrigger: PublishRelay<Void>
    }
    
    func transform(input: Input) -> Output {
        let pushSearchTrigger = PublishRelay<String>()
        let pushDetailTrigger = PublishRelay<CoinBasicInfo>()
        let searchBarClearTigger = PublishRelay<Void>()
                
        input.viewDidLoadTrigger
            .bind(with: self) { owner, _ in
                owner.fetchTrendData(isFirst: true, isRetry: false)
            }
            .disposed(by: disposeBag)
        
        input.isTimerRunning
            .distinctUntilChanged()
            .filter { $0 == true }  // 화면 복귀(true)일 때만
            .skip(1)  // 최초 진입은 viewDidLoad에서 처리하므로 제외
            .bind(with: self) { owner, _ in
                owner.checkAndUpdateIfNeeded()
            }
            .disposed(by: disposeBag)

        input.isTimerRunning
            .bind(with: self) { owner, isRunning in
                owner.isRunning = isRunning
            }
            .disposed(by: disposeBag)
        
        input.networkRetryTrigger
            .bind(with: self) { owner, _ in
                if owner.isFetched {
                    owner.fetchTrendData(isFirst: true, isRetry: true)
                }
            }
            .disposed(by: disposeBag)
        
        input.dismissDialogTrigger
            .bind(with: self) { owner, _ in
                owner.isDismissDialog = true
            }
            .disposed(by: disposeBag)
        
        // MARK: 코인 선택 - 상세 뷰 이동
        input.selectedCoin
            .map { $0.asCoinBasicInfo }
            .bind() { coinInfo in
                pushDetailTrigger.accept(coinInfo)
            }
            .disposed(by: disposeBag)
        
        // MARK: 검색 - 검색 뷰 이동
        input.returnButtonTapped
            .withLatestFrom(input.searchText.orEmpty)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .bind() { text in
                if !text.isEmpty {
                    pushSearchTrigger.accept(text)
                }
                searchBarClearTigger.accept(())
            }
            .disposed(by: disposeBag)
        
        
        return Output(showIndicatorTrigger: showIndicatorTrigger.asDriver(),
                      updateTimeText: updateTimeText.asDriver(),
                      TrendCoinData: TrendCoinData.asDriver(),
                      trendNFTData: trendNFTData.asDriver(),
                      dialogTrigger: dialogTrigger.asDriver(onErrorJustReturn: nil),
                      pushSearchTrigger: pushSearchTrigger,
                      pushDetailTrigger: pushDetailTrigger,
                      searchBarClearTigger: searchBarClearTigger,
                      monitorDialogTrigger: monitorDialogTrigger.asDriver(onErrorJustReturn: nil),
                      toastTrigger: toastTrigger)
    }
}

// MARK: - 네트워크 통신
extension TrendViewModel {
    /// 화면 복귀 시 마지막 업데이트 시간 체크 후 조건부 업데이트
    private func checkAndUpdateIfNeeded() {
        guard let lastUpdate = lastUpdateTime else {
            // 최초 업데이트가 없으면 즉시 호출
            fetchTrendData(isFirst: false, isRetry: false)
            return
        }

        let elapsedTime = Date().timeIntervalSince(lastUpdate)

        if elapsedTime >= updateInterval {
            // 10분 이상 경과 → 즉시 업데이트
            fetchTrendData(isFirst: false, isRetry: false)
        }
        // 10분 미만이면 아무것도 하지 않음 (타이머가 알아서 처리)
    }

    private func fetchTrendData(isFirst: Bool, isRetry: Bool) {
        guard monitor.isConnected else {
            if isDismissDialog {
                monitorDialogTrigger.accept(())
                isDismissDialog = false
            } else if isRetry {
                toastTrigger.accept(())
            }
            return
        }
        
        NetworkManager.executeFetch(
            router: CoingeckoRouter.trend,
            response: CoingeckoTrendResponse.self
        )
        .bind(with: self) { owner, result in
            if isFirst {
                // 타이머 시작: 10분마다 실행
                Driver<Int>.interval(.seconds(600))
                    .asObservable()
                    .startWith(-1)
                    .bind(with: owner) { owner, _ in
                        // 화면에 있을 때만 API 호출
                        if owner.isRunning {
                            owner.fetchTrendData(isFirst: false, isRetry: false)
                        }
                    }
                    .disposed(by: owner.disposeBag)
            }
            switch result {
            case .success(let response):
                // ✅ 업데이트 성공 시 시간 기록
                owner.lastUpdateTime = Date()
                owner.updateTimeText.accept(FormatHelper.shared.trendUpdateTime(Date()))
                owner.TrendCoinData.accept(response.coins.prefix(14).map { $0.asTrendCoins })
                owner.trendNFTData.accept(response.nfts.map { $0.asTrendNFTs })
            case .failure(let error):
                if owner.isDismissDialog {
                    switch error {
                    case .lostNetwork:
                        owner.monitorDialogTrigger.accept(())
                    default:
                        owner.dialogTrigger.accept(error.message)
                    }
                    owner.isDismissDialog = false
                }
            }
            owner.showIndicatorTrigger.accept(false)
            owner.isFetched = true
            owner.isDismissDialog = true
        }
        .disposed(by: disposeBag)
    }
}

