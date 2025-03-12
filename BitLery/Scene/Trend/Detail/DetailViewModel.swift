//
//  DetailViewModel.swift
//  BitLery
//
//  Created by 정인선 on 3/8/25.
//

import Foundation
import RxCocoa
import RxSwift

final class DetailViewModel: BaseViewModel {
    private let monitor = NetworkMonitorService.shared
    private let realm = RealmDataRepository.shared
    private let coinInfo: CoinBasicInfo
    var disposeBag = DisposeBag()
    
    private let showIndicatorTrigger = BehaviorRelay(value: true)
    private let marketData = PublishRelay<CoinMarket?>()
    private let dialogTrigger = PublishRelay<String?>()
    private let monitorDialogTrigger = PublishRelay<Void?>()
    private let networkToastTrigger = PublishRelay<Void>()
    
    private var isDismissDialog = true
    
    init(_ coinInfo: CoinBasicInfo) {
        self.coinInfo = coinInfo
    }
    
    struct Input {
        let viewDidLoadTrigger: PublishRelay<Void>
        let likeButtonTapped: ControlEvent<Void>
        let infoMoreButtonTapped: ControlEvent<Void>
        let volumeMoreButtonTapped: ControlEvent<Void>
        let networkRetryTrigger: PublishRelay<Void>
    }
    struct Output {
        let setStarButton: BehaviorRelay<Bool>
        let updateTrigger: PublishRelay<Void>
        let showIndicatorTrigger: Driver<Bool>
        let setUITrigger: Observable<CoinBasicInfo>
        let marketData: Driver<CoinMarket?>
        let dialogTrigger: Driver<String?>
        let monitorDialogTrigger: Driver<Void?>
        let toastTrigger: PublishRelay<String>
        let networkToastTrigger: PublishRelay<Void>
    }
    
    func transform(input: Input) -> Output {
        let setStarButton = BehaviorRelay(value: false)
        let updateTrigger = PublishRelay<Void>()
        let likeButtonTapped = input.likeButtonTapped.share()
        let toastTrigger = PublishRelay<String>()
        
        input.viewDidLoadTrigger
            .bind(with: self) { owner, _ in
                if owner.realm.readTable(type: CoinTable.self).contains(where: { $0.id == owner.coinInfo.id }) {
                    setStarButton.accept(true)
                } else {
                    setStarButton.accept(false)
                }
                
                if owner.monitor.isConnected {
                    owner.fetchMarketData(owner.coinInfo.id)
                } else if owner.isDismissDialog {
                    owner.showIndicatorTrigger.accept(false)
                    owner.monitorDialogTrigger.accept(())
                    owner.isDismissDialog = false
                }
            }
            .disposed(by: disposeBag)
        
        input.networkRetryTrigger
            .bind(with: self) { owner, _ in
                if owner.monitor.isConnected {
                    owner.isDismissDialog = true
                    owner.showIndicatorTrigger.accept(true)
                    owner.fetchMarketData(owner.coinInfo.id)
                } else {
                    owner.networkToastTrigger.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        likeButtonTapped
            .bind(with: self) { owner, _ in
                let isLiked = setStarButton.value
                setStarButton.accept(!isLiked)
            }
            .disposed(by: disposeBag)
        
        likeButtonTapped
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                if setStarButton.value {
                    do {
                        try owner.realm.addItem(type: CoinTable.self, item: CoinTable(id: owner.coinInfo.id))
                        updateTrigger.accept(())
                        toastTrigger.accept("\(owner.coinInfo.name)이 즐겨찾기되었습니다")
                    } catch {
                        
                    }
                } else {
                    do {
                        if let coin = owner.realm.readTable(type: CoinTable.self).first(where: { $0.id == owner.coinInfo.id }) {
                            try owner.realm.deleteItem(type: CoinTable.self, item: coin)
                            updateTrigger.accept(())
                            toastTrigger.accept("\(owner.coinInfo.name)이 즐겨찾기에서 제거되었습니다")
                        }
                    } catch {
                        print(error)
                    }
                }
                
            }
            .disposed(by: disposeBag)
        
        input.infoMoreButtonTapped
            .bind() { _ in
                toastTrigger.accept("준비중입니다")
            }
            .disposed(by: disposeBag)
        
        input.volumeMoreButtonTapped
            .bind() { _ in
                toastTrigger.accept("준비중입니다")
            }
            .disposed(by: disposeBag)
        
        return Output(setStarButton: setStarButton,
                      updateTrigger: updateTrigger,
                      showIndicatorTrigger: showIndicatorTrigger.asDriver(),
                      setUITrigger: Observable.just(coinInfo),
                      marketData: marketData.asDriver(onErrorJustReturn: nil),
                      dialogTrigger: dialogTrigger.asDriver(onErrorJustReturn: nil),
                      monitorDialogTrigger: monitorDialogTrigger.asDriver(onErrorJustReturn: nil),
                      toastTrigger: toastTrigger,
                      networkToastTrigger: networkToastTrigger)
    }
}

extension DetailViewModel {
    private func fetchMarketData(_ id: String) {
        NetworkManager.executeFetch(
            router: CoingeckoRouter.market(dto: CoingeckoMarketRequest(ids: id)),
            response: [CoingeckoMarketResponse].self
        )
        .bind(with: self) { owner, result in
            switch result {
            case .success(let response):
                if let coinMarket = response.map({ $0.asCoinMarket }).first {
                    owner.marketData.accept(coinMarket)
                } else {
                    owner.dialogTrigger.accept("코인 정보가 없습니다.")
                }
            case .failure(let error):
                switch error {
                case .lostNetwork:
                    owner.monitorDialogTrigger.accept(())
                    owner.isDismissDialog = false
                default:
                    owner.dialogTrigger.accept(error.message)
                    owner.isDismissDialog = false
                }
            }
            owner.showIndicatorTrigger.accept(false)
        }
        .disposed(by: disposeBag)
    }
}
