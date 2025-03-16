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
    private let monitor = NetworkMonitorService.shared
    private let realm = RealmDataRepository.shared
    var disposeBag = DisposeBag()

    private let showIndicatorTrigger = BehaviorRelay(value: true)
    private let searchCoinData = BehaviorRelay(value: [SearchCoin]())
    private let collectionHiddenTrigger = BehaviorRelay(value: false)
    private let dialogTrigger = PublishRelay<String?>()
    private let monitorDialogTrigger = PublishRelay<Void?>()
    private let networkToastTrigger = PublishRelay<Void>()

    private let searchText: BehaviorRelay<String>
    let initialSearchText: String  // ViewController에서 접근 가능하도록 public

    init(_ searchText: String) {
        self.searchText = BehaviorRelay(value: searchText)
        self.initialSearchText = searchText
    }
    
    struct Input {
        let likedCoinID: PublishRelay<String>
        let reloadDataTrigger: PublishRelay<Void>
        let returnButtonTapped: ControlEvent<Void>
        let searchText: ControlProperty<String?>
        let selectedCoin: ControlEvent<SearchCoin>
        let networkRetryTrigger: PublishRelay<Void>
    }
    struct Output {
        let showIndicatorTrigger: Driver<Bool>
        let setUITrigger: Observable<String>
        let searchCoinData: Driver<[SearchCoin]>
        let collectionHiddenTrigger: Driver<Bool>
        let pushDetailTrigger: PublishRelay<CoinBasicInfo>
        let dialogTrigger: Driver<String?>
        let monitorDialogTrigger: Driver<Void?>
        let toastTrigger: PublishRelay<String>
        let networkToastTrigger: PublishRelay<Void>
    }
    
    func transform(input: Input) -> Output {
        let pushDetailTrigger = PublishRelay<CoinBasicInfo>()
        let toastTrigger = PublishRelay<String>()
        
        // MARK: - 좋아요
        let likedCoinID = input.likedCoinID.share()
        
        likedCoinID
            .bind(with: self) { owner, id in
                guard let index = owner.searchCoinData.value.firstIndex(where: { $0.id == id }) else { return }
                var coinData = owner.searchCoinData.value
                var coin = coinData[index]
                coin.isLiked.toggle()
                coinData[index] = coin
                owner.searchCoinData.accept(coinData)
            }
            .disposed(by: disposeBag)
        
        likedCoinID
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, id in
                guard let index = owner.searchCoinData.value.firstIndex(where: { $0.id == id }) else { return }
                let coinData = owner.searchCoinData.value
                let coin = coinData[index]

                do {
                    if coin.isLiked {
                        try owner.realm.addItem(type: CoinTable.self, item: CoinTable(id: id))
                        toastTrigger.accept("\(coin.name)이 즐겨찾기되었습니다")
                    } else {
                        if let realmCoin = owner.realm.readTable(type: CoinTable.self).first(where: { $0.id == id }) {
                            try owner.realm.deleteItem(type: CoinTable.self, item: realmCoin)
                            toastTrigger.accept("\(coin.name)이 즐겨찾기에서 제거되었습니다")
                        }
                    }
                } catch {
                    // Realm 저장/삭제 실패 시 UI 롤백
                    owner.rollbackLikeState(id: id)
                    toastTrigger.accept("즐겨찾기 처리에 실패했습니다")
                    print("❌ Realm Error:", error)
                }
            }
            .disposed(by: disposeBag)
        
        input.reloadDataTrigger
            .bind(with: self) { owner, _ in
                owner.mappingRealmData(owner.searchCoinData.value)
            }
            .disposed(by: disposeBag)
        
        // MARK: - Trend 뷰에서 받은 검색어를 통한 검색
        searchText
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                owner.fetchSearchWithMonitor(text)
            }
            .disposed(by: disposeBag)
        
        input.networkRetryTrigger
            .bind(with: self) { owner, _ in
                owner.fetchSearchWithMonitor(owner.searchText.value)
            }
            .disposed(by: disposeBag)
        
        // MARK: - 실시간 검색
        input.searchText
            .orEmpty
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                if !text.isEmpty {
                    owner.searchText.accept(text)
                } else {
                    owner.collectionHiddenTrigger.accept(true)
                    owner.searchCoinData.accept([])
                }
            }
            .disposed(by: disposeBag)

        // MARK: - 엔터 키 검색 (즉시 실행)
        input.returnButtonTapped
            .withLatestFrom(input.searchText.orEmpty)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .bind(with: self) { owner, text in
                if !text.isEmpty {
                    owner.searchText.accept(text)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: - 코인 셀 선택 -> 디테일 뷰 이동
        input.selectedCoin
            .map { $0.asCoinBasicInfo }
            .bind() { coinInfo in
                pushDetailTrigger.accept(coinInfo)
            }
            .disposed(by: disposeBag)
        
        return Output(showIndicatorTrigger: showIndicatorTrigger.asDriver(),
                      setUITrigger: Observable.just(searchText.value),
                      searchCoinData: searchCoinData.asDriver(),
                      collectionHiddenTrigger: collectionHiddenTrigger.asDriver(),
                      pushDetailTrigger: pushDetailTrigger,
                      dialogTrigger: dialogTrigger.asDriver(onErrorJustReturn: nil),
                      monitorDialogTrigger: monitorDialogTrigger.asDriver(onErrorJustReturn: nil),
                      toastTrigger: toastTrigger,
                      networkToastTrigger: networkToastTrigger)
    }
}

extension SearchViewModel {
    /// UI에 반영된 좋아요 상태를 롤백 (Realm 작업 실패 시)
    private func rollbackLikeState(id: String) {
        guard let index = searchCoinData.value.firstIndex(where: { $0.id == id }) else { return }
        var coinData = searchCoinData.value
        var coin = coinData[index]
        coin.isLiked.toggle() // 원래 상태로 되돌림
        coinData[index] = coin
        searchCoinData.accept(coinData)
    }

    private func fetchSearchWithMonitor(_ text: String) {
        if !monitor.isConnected {
            monitorDialogTrigger.accept(())
        } else {
            if !showIndicatorTrigger.value {
                showIndicatorTrigger.accept(true)
            }
            fetchSearchData(text)
        }
    }
    
    private func fetchSearchData(_ text: String) {
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
                    let coinData = response.coins.map { $0.asSearchCoin }
                    owner.mappingRealmData(coinData)
                }
            case .failure(let error):
                switch error {
                case .lostNetwork:
                    owner.monitorDialogTrigger.accept(())
                default:
                    owner.dialogTrigger.accept(error.message)
                }
            }
            owner.showIndicatorTrigger.accept(false)
        }
        .disposed(by: disposeBag)
    }
    
    private func mappingRealmData(_ coinData: [SearchCoin]) {
        var coins = coinData
        let likedCoins = realm.readTable(type: CoinTable.self)
        coins.enumerated().forEach { index, coin in
            coins[index].isLiked = likedCoins.contains(where: { $0.id == coin.id })
        }
        searchCoinData.accept(coins)
    }
}
