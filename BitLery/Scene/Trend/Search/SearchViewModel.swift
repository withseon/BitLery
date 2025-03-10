//
//  SearchViewModel.swift
//  BitLery
//
//  Created by 정인선 on 3/9/25.
//

import Foundation
import RxCocoa
import RxSwift

final class SearchViewModel: BaseViewModel {
    private let searchText: BehaviorRelay<String>
    var disposeBag = DisposeBag()
    
    private let showIndicatorTrigger = BehaviorRelay(value: true)
    private let searchCoinData = BehaviorRelay(value: [SearchCoin]())
    private let collectionHiddenTrigger = BehaviorRelay(value: false)
    private let dialogTrigger = PublishRelay<(message: String, buttonTitle: String)?>()
    
    init(_ searchText: String) {
        self.searchText = BehaviorRelay(value: searchText)
    }
    
    struct Input {
        let leftButtonTapped: ControlEvent<Void>
        let returnButtonTapped: ControlEvent<Void>
        let searchText: ControlProperty<String?>
        let selectedCoin: ControlEvent<SearchCoin>
    }
    struct Output {
        let showIndicatorTrigger: Driver<Bool>
        let setUITrigger: Observable<String>
        let popTrigger: PublishRelay<Void>
        let searchCoinData: Driver<[SearchCoin]>
        let collectionHiddenTrigger: Driver<Bool>
        let pushDetailTrigger: PublishRelay<CoinBasicInfo>
        let dialogTrigger: Driver<(message: String, buttonTitle: String)?>
    }
    
    func transform(input: Input) -> Output {
        let popTrigger = PublishRelay<Void>()
        let pushDetailTrigger = PublishRelay<CoinBasicInfo>()
        
        // MARK: - Trend 뷰에서 받은 검색어를 통한 검색
        searchText
            .bind(with: self) { owner, text in
                if !owner.showIndicatorTrigger.value {
                    owner.showIndicatorTrigger.accept(true)
                }
                owner.fetchSearchData(text)
            }
            .dispose()
        
        // MARK: - 네비게이션으로 검색
        input.returnButtonTapped
            .withLatestFrom(input.searchText.orEmpty)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                if !text.isEmpty {
                    owner.fetchSearchData(text)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: - 네비게이션 Back
        input.leftButtonTapped
            .bind{ _ in
                popTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        // MARK: - 코인 셀 선택 -> 디테일 뷰 이동
        // TODO: 쓰로틀
        input.selectedCoin
            .map { $0.asCoinBasicInfo }
            .bind() { coinInfo in
                pushDetailTrigger.accept(coinInfo)
            }
            .disposed(by: disposeBag)
        
        return Output(showIndicatorTrigger: showIndicatorTrigger.asDriver(),
                      setUITrigger: Observable.just(searchText.value),
                      popTrigger: popTrigger,
                      searchCoinData: searchCoinData.asDriver(),
                      collectionHiddenTrigger: collectionHiddenTrigger.asDriver(),
                      pushDetailTrigger: pushDetailTrigger,
                      dialogTrigger: dialogTrigger.asDriver(onErrorJustReturn: nil))
    }
}

extension SearchViewModel {
    private func fetchSearchData(_ text: String) {
        print("검색됐지롱")
        NetworkManager.executeFetch(
            router: CoingeckoRouter.search(dto: CoingeckoSearchRequest(query: text)),
            response: CoingeckoSearchResponse.self
        )
        .bind(with: self) { owner, result in
            switch result {
            case .success(let response):
                if response.coins.isEmpty {
                    owner.collectionHiddenTrigger.accept(true)
                } else {
                    owner.collectionHiddenTrigger.accept(false)
                    owner.searchCoinData.accept(response.coins.map { $0.asSearchCoin })
                }
            case .failure(let error):
                owner.dialogTrigger.accept((error.message, "확인"))
            }
            owner.showIndicatorTrigger.accept(false)
        }
        .disposed(by: disposeBag)
    }
}
