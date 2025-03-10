//
//  TrendViewController.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class TrendViewController: BaseViewController {
    private let searchBar = CustomSearchBar()
    private let searchTitleLabel = TitleLabel("인기 검색어")
    private let updateTimeLabel = UILabel()
    private let coinCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: BaseCollectionViewCell.trendCoinCell())
    private let nftTitleLabel = TitleLabel("인기 NFT")
    private let nftCollectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: BaseCollectionViewCell.trendNFTCell())
    
    private let disposeBag = DisposeBag()
    private let viewModel = TrendViewModel()
    
    private let viewAppearTrigger = PublishRelay<Void>()
    private let viewDisappearTrigger = PublishRelay<Void>()
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        viewAppearTrigger.accept(())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewDisappearTrigger.accept(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bind()
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        setNavigationLargeTitle("가상자산 / 심볼 검색")
    }
    
    override func configureHierarchy() {
        [navigationBar, searchBar,
         searchTitleLabel, updateTimeLabel, coinCollectionView,
         nftTitleLabel, nftCollectionView].forEach { view in
            self.view.addSubview(view)
        }
    }
    
    override func configureLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        searchTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        updateTimeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(searchTitleLabel)
            make.trailing.equalToSuperview().inset(20)
        }
        coinCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTitleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(320)
        }
        nftTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(coinCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        nftCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nftTitleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.bottom.greaterThanOrEqualTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureView() {
        updateTimeLabel.font = Resource.SystemFont.regular12
        updateTimeLabel.textColor = .labelSecondary
        updateTimeLabel.textAlignment = .right
    }
}

// MARK: - 컬렉션 뷰
extension TrendViewController {
    private func configureCollectionView() {
        coinCollectionView.register(CoinTrendCollectionViewCell.self, forCellWithReuseIdentifier: CoinTrendCollectionViewCell.identifier)
        nftCollectionView.register(NFTTrendCollectionViewCell.self, forCellWithReuseIdentifier: NFTTrendCollectionViewCell.identifier)
        coinCollectionView.isScrollEnabled = false
        nftCollectionView.isScrollEnabled = false
    }
}

// MARK: - bind
extension TrendViewController {
    private func bind() {
        let input = TrendViewModel.Input(viewAppearTrigger: viewAppearTrigger,
                                         viewDisappearTrigger: viewDisappearTrigger,
                                         returnButtonTapped: searchBar.textField.rx.controlEvent(.editingDidEndOnExit),
                                         searchText: searchBar.textField.rx.text,
                                         selectedCoin: coinCollectionView.rx.modelSelected(TrendCoin.self))
        let output = viewModel.transform(input: input)
        
        output.updateTimeText
            .drive(with: self) { owner, text in
                owner.updateTimeLabel.text = text
            }
            .disposed(by: disposeBag)
        
        output.TrendCoinData
            .drive(coinCollectionView.rx.items(
                cellIdentifier: CoinTrendCollectionViewCell.identifier,
                cellType: CoinTrendCollectionViewCell.self)
            ) { row, element, cell in
                cell.setContent(rank: String(row + 1), coin: element)
            }
            .disposed(by: disposeBag)
        
        output.trendNFTData
            .drive(nftCollectionView.rx.items(
                cellIdentifier: NFTTrendCollectionViewCell.identifier,
                cellType: NFTTrendCollectionViewCell.self)
            ) { _, element, cell in
                cell.setContent(nft: element)
            }
            .disposed(by: disposeBag)
        
        output.pushSearchTrigger
            .bind(with: self) { owner, text in
                let vc = SearchViewController(text)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.pushDetailTrigger
            .bind(with: self) { owner, coinID in
                let vc = DetailViewController(coinID)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.searchBarClearTigger
            .bind(with: self) { owner, _ in
                owner.searchBar.textField.text = nil
            }
            .disposed(by: disposeBag)
        
        output.dialogTrigger
            .drive(with: self) { owner, content in
                guard let content else { return }
                owner.showDialog(message: content.message, buttonTitle: content.buttonTitle)
            }
            .disposed(by: disposeBag)
    }
}
