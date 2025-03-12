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
                Driver<Int>.interval(.seconds(600))
                    .asObservable()
                    .startWith(-1)
                    .withLatestFrom(Observable.just(owner.isRunning))
                    .bind(with: owner) { owner, isRunning in
                        if isRunning {
                            owner.fetchTrendData(isFirst: false, isRetry: false)
                        }
                    }
                    .disposed(by: owner.disposeBag)
            }
            switch result {
            case .success(let response):
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

