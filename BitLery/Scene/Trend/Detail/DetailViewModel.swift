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
    private let coinInfo: BehaviorRelay<CoinBasicInfo>
    var disposeBag = DisposeBag()
    
    private let showIndicatorTrigger = BehaviorRelay(value: true)
    private let marketData = PublishRelay<CoinMarket?>()
    private let dialogTrigger = PublishRelay<(message: String, buttonTitle: String)?>()
    
    init(_ coinInfo: CoinBasicInfo) {
        self.coinInfo = BehaviorRelay(value: coinInfo)
    }
    
    struct Input {
        let infoMoreButtonTapped: ControlEvent<Void>
        let volumeMoreButtonTapped: ControlEvent<Void>
    }
    struct Output {
        let showIndicatorTrigger: Driver<Bool>
        let setUITrigger: Observable<CoinBasicInfo>
        let marketData: Driver<CoinMarket?>
        let dialogTrigger: Driver<(message: String, buttonTitle: String)?>
        let toastTrigger: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output {
        let toastTrigger = PublishRelay<String>()
        
        coinInfo
            .map { $0.id }
            .bind(with: self) { owner, id in
                if !owner.showIndicatorTrigger.value {
                    owner.showIndicatorTrigger.accept(true)
                }
                owner.fetchMarketData(id)
            }
            .dispose()
        
        input.infoMoreButtonTapped
            .bind() { _ in
                toastTrigger.accept("준비중입니다.")
            }
            .disposed(by: disposeBag)
        
        input.volumeMoreButtonTapped
            .bind() { _ in
                toastTrigger.accept("준비중입니다.")
            }
            .disposed(by: disposeBag)
        
        return Output(showIndicatorTrigger: showIndicatorTrigger.asDriver(),
                      setUITrigger: Observable.just(coinInfo.value),
                      marketData: marketData.asDriver(onErrorJustReturn: nil),
                      dialogTrigger: dialogTrigger.asDriver(onErrorJustReturn: nil),
                      toastTrigger: toastTrigger)
    }
}

extension DetailViewModel {
    private func fetchMarketData(_ id: String) {
        print("호출됐찌롱")
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
                    owner.dialogTrigger.accept(("코인 정보가 없습니다.", "확인"))
                }
            case .failure(let error):
                owner.dialogTrigger.accept((error.message, "확인"))
            }
            owner.showIndicatorTrigger.accept(false)
        }
        .disposed(by: disposeBag)
    }
}
