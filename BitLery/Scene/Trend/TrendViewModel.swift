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
    var disposeBag = DisposeBag()
    
    private let updateTimeText = BehaviorRelay(value: "")
    private let TrendCoinData = BehaviorRelay(value: [TrendCoin]())
    private let trendNFTData = BehaviorRelay(value: [TrendNFT]())
    private let dialogTrigger = PublishRelay<(message: String, buttonTitle: String)?>()
    
    struct Input {
        let viewAppearTrigger: PublishRelay<Void>
        let viewDisappearTrigger: PublishRelay<Void>
        let returnButtonTapped: ControlEvent<Void>
        let searchText: ControlProperty<String?>
        let selectedCoin: ControlEvent<TrendCoin>
    }
    struct Output {
        let updateTimeText: Driver<String>
        let TrendCoinData: Driver<[TrendCoin]>
        let trendNFTData: Driver<[TrendNFT]>
        let dialogTrigger: Driver<(message: String, buttonTitle: String)?>
        let pushSearchTrigger: PublishRelay<String>
        let pushDetailTrigger: PublishRelay<CoinBasicInfo>
        let searchBarClearTigger: PublishRelay<Void>
    }
    
    func transform(input: Input) -> Output {
        let pushSearchTrigger = PublishRelay<String>()
        let pushDetailTrigger = PublishRelay<CoinBasicInfo>()
        let searchBarClearTigger = PublishRelay<Void>()
        let isRunningTimer = BehaviorRelay(value: false)
        let timer = Observable<Int>.interval(.seconds(600), scheduler: MainScheduler.instance)
            .startWith(-1)
        
        // MARK: 데이터 페치
        isRunningTimer
            .flatMapLatest { isRunning in
                return isRunning ? timer.debug("Timer") : .empty()
            }
            .debug("RunningTimer")
            .subscribe(with: self) { owner, _ in
                owner.fetchTrendData()
            }
            .disposed(by: disposeBag)

        input.viewAppearTrigger
            .bind(with: self) { owner, _ in
                isRunningTimer.accept(true)
            }
            .disposed(by: disposeBag)
        
        input.viewDisappearTrigger
            .bind(with: self) { owner, _ in
                isRunningTimer.accept(false)
            }
            .disposed(by: disposeBag)
        
        // MARK: 코인 선택 - 상세 뷰 이동
        // TODO: 쓰로틀
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
        
        
        return Output(updateTimeText: updateTimeText.asDriver(),
                      TrendCoinData: TrendCoinData.asDriver(),
                      trendNFTData: trendNFTData.asDriver(),
                      dialogTrigger: dialogTrigger.asDriver(onErrorJustReturn: nil),
                      pushSearchTrigger: pushSearchTrigger,
                      pushDetailTrigger: pushDetailTrigger,
                      searchBarClearTigger: searchBarClearTigger)
    }
}

// MARK: - 네트워크 통신
extension TrendViewModel {
    private func fetchTrendData() {
        NetworkManager.executeFetch(
            router: CoingeckoRouter.trend,
            response: CoingeckoTrendResponse.self
        )
        .bind(with: self) { owner, result in
            switch result {
            case .success(let response):
                owner.updateTimeText.accept(FormatManager.shared.trendUpdateTime(Date()))
                owner.TrendCoinData.accept(response.coins.prefix(14).map { $0.asTrendCoins })
                owner.trendNFTData.accept(response.nfts.map { $0.asTrendNFTs })
            case .failure(let error):
                owner.dialogTrigger.accept((error.message, "확인"))
            }
        }
        .disposed(by: disposeBag)
    }
}
