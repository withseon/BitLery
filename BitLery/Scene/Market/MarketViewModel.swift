//
//  MarketViewModel.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import Foundation
import RxCocoa
import RxSwift

final class MarketViewModel: BaseViewModel {
    enum SortType {
        case tradePriceAsc
        case tradePriceDesc
        case rateAsc
        case rateDesc
        case accPriceAsc
        case accPriceDesc
        case initial
    }
    private let monitor = NetworkMonitorService.shared
    var disposeBag = DisposeBag()
    private var isFetched = false
    private var isRunning = true
    private let showIndicatorTrigger = BehaviorRelay(value: true)
    private let tickerData = PublishRelay<[Ticker]>()
    private let dialogTrigger = PublishRelay<String?>()
    private let monitorDialogTrigger = PublishRelay<Void?>()
    private var isDismissDialog = true
    private let toastTrigger = PublishRelay<Void>()

    private var lastUpdateTime: Date?  // 마지막 업데이트 시간 추적
    private let updateInterval: TimeInterval = 5  // 5초
    
    struct Input {
        let viewDidLoadTrigger: PublishRelay<Void>
        let isTimerRunning: BehaviorRelay<Bool>
        let tradePriceButtonTapped: ControlEvent<Void>
        let rateButtonTapped: ControlEvent<Void>
        let accPriceButtonTapped: ControlEvent<Void>
        let networkRetryTrigger: PublishRelay<Void>
        let dismissDialogTrigger: PublishRelay<Void>
    }
    
    struct Output {
        let showIndicatorTrigger: Driver<Bool>
        let tickerData: Driver<[Ticker]>
        // 버튼 상태 -1, 0, 1
        let changeTradePriceButton: Driver<Int>
        let changeRateButton: Driver<Int>
        let changeAccPriceButton: Driver<Int>
        let dialogTrigger: Driver<String?>
        let monitorDialogTrigger: Driver<Void?>
        let toastTrigger: PublishRelay<Void>
    }
    
    func transform(input: Input) -> Output {
        let sortType = BehaviorRelay(value: SortType.initial)
        let sortedTickerData = BehaviorRelay(value: [Ticker]())
        let changeTradePriceButton = BehaviorRelay(value: 0)
        let changeRateButton = BehaviorRelay(value: 0)
        let changeAccPriceButton = BehaviorRelay(value: 0)
        
        input.viewDidLoadTrigger
            .bind(with: self) { owner, _ in
                owner.fetchTickerData(isFirst: true, isRetry: false)
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
                    owner.fetchTickerData(isFirst: true, isRetry: true)
                }
            }
            .disposed(by: disposeBag)
        
        input.dismissDialogTrigger
            .bind(with: self) { owner, _ in
                owner.isDismissDialog = true
            }
            .disposed(by: disposeBag)

        input.tradePriceButtonTapped
            .map {
                switch sortType.value {
                case .tradePriceAsc:
                    changeTradePriceButton.accept(0)
                    return .initial
                case .tradePriceDesc:
                    changeTradePriceButton.accept(1)
                    return .tradePriceAsc
                case .initial:
                    changeTradePriceButton.accept(-1)
                    return .tradePriceDesc
                default:
                    changeTradePriceButton.accept(-1)
                    changeRateButton.accept(0)
                    changeAccPriceButton.accept(0)
                    return .tradePriceDesc
                }
            }
            .bind(with: self) { owner, newSortType in
                sortType.accept(newSortType)
            }
            .disposed(by: disposeBag)
        
        input.rateButtonTapped
            .map {
                switch sortType.value {
                case .rateAsc:
                    changeRateButton.accept(0)
                    return .initial
                case .rateDesc:
                    changeRateButton.accept(1)
                    return .rateAsc
                case .initial:
                    changeRateButton.accept(-1)
                    return .rateDesc
                default:
                    changeRateButton.accept(-1)
                    changeTradePriceButton.accept(0)
                    changeAccPriceButton.accept(0)
                    return .rateDesc
                }
            }
            .bind(with: self) { owner, newSortType in
                sortType.accept(newSortType)
            }
            .disposed(by: disposeBag)
        
        input.accPriceButtonTapped
            .map {
                switch sortType.value {
                case .accPriceAsc:
                    changeAccPriceButton.accept(0)
                    return .initial
                case .accPriceDesc:
                    changeAccPriceButton.accept(1)
                    return .accPriceAsc
                case .initial:
                    changeAccPriceButton.accept(-1)
                    return .accPriceDesc
                default:
                    changeAccPriceButton.accept(-1)
                    changeTradePriceButton.accept(0)
                    changeRateButton.accept(0)
                    return .accPriceDesc
                }
            }
            .bind(with: self) { owner, newSortType in
                sortType.accept(newSortType)
            }
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(sortType, tickerData)
            .map { sort, tickers in
                switch sort {
                case .tradePriceAsc:
                    return tickers.sorted { $0.tradePrice < $1.tradePrice }
                case .tradePriceDesc:
                    return tickers.sorted { $0.tradePrice > $1.tradePrice }
                case .rateAsc:
                    return tickers.sorted { $0.changedRate < $1.changedRate }
                case .rateDesc:
                    return tickers.sorted { $0.changedRate > $1.changedRate }
                case .accPriceAsc:
                    return tickers.sorted { $0.accTradePrice < $1.accTradePrice }
                case .accPriceDesc, .initial:
                    return tickers.sorted { $0.accTradePrice > $1.accTradePrice }
                }
            }
            .bind() { sortedTickers in
                sortedTickerData.accept(sortedTickers)
            }
            .disposed(by: disposeBag)
        
        return Output(showIndicatorTrigger: showIndicatorTrigger.asDriver(),
                      tickerData: sortedTickerData.asDriver(),
                      changeTradePriceButton: changeTradePriceButton.asDriver(),
                      changeRateButton: changeRateButton.asDriver(),
                      changeAccPriceButton: changeAccPriceButton.asDriver(),
                      dialogTrigger: dialogTrigger.asDriver(onErrorJustReturn: nil),
                      monitorDialogTrigger: monitorDialogTrigger.asDriver(onErrorJustReturn: nil),
                      toastTrigger: toastTrigger)
    }
}

extension MarketViewModel {
    /// 화면 복귀 시 마지막 업데이트 시간 체크 후 조건부 업데이트
    private func checkAndUpdateIfNeeded() {
        guard let lastUpdate = lastUpdateTime else {
            // 최초 업데이트가 없으면 즉시 호출
            fetchTickerData(isFirst: false, isRetry: false)
            return
        }

        let elapsedTime = Date().timeIntervalSince(lastUpdate)

        if elapsedTime >= updateInterval {
            // 5초 이상 경과 → 즉시 업데이트
            fetchTickerData(isFirst: false, isRetry: false)
        }
        // 5초 미만이면 아무것도 하지 않음 (타이머가 알아서 처리)
    }

    private func fetchTickerData(isFirst: Bool, isRetry: Bool) {
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
            router: UpbitRouter.ticker(dto: UpbitTickerRequest()),
            response: [UpbitTickerResponse].self
        )
        .bind(with: self) { owner, result in
            if isFirst {
                // 타이머 시작: 5초마다 실행
                Driver<Int>.interval(.seconds(5))
                    .asObservable()
                    .startWith(-1)
                    .bind(with: owner) { owner, _ in
                        // 화면에 있을 때만 API 호출
                        if owner.isRunning {
                            owner.fetchTickerData(isFirst: false, isRetry: false)
                        }
                    }
                    .disposed(by: owner.disposeBag)
            }
            switch result {
            case .success(let response):
                // ✅ 업데이트 성공 시 시간 기록
                owner.lastUpdateTime = Date()
                owner.tickerData.accept(response.map { $0.asTicker })
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
