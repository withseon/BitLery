//
//  SearchViewController.swift
//  BitLery
//
//  Created by 정인선 on 3/9/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class SearchViewController: BaseViewController {
    private let bodyView = UIView()
    private var searchTabVC = SearchTabViewController()
    
    private let disposeBag = DisposeBag()
    private let viewModel: SearchViewModel
    
    init(_ text: String) {
        viewModel = SearchViewModel(text)
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabView()  // bind() 전에 먼저 호출
        navigationBar.textField.text = viewModel.initialSearchText  // 초기 검색어 설정
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func configureHierarchy() {
        view.addSubview(navigationBar)
        view.addSubview(bodyView)
    }
    
    override func configureLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        bodyView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension SearchViewController {
    private func configureTabView() {
        addChild(searchTabVC)
        bodyView.addSubview(searchTabVC.view)
        searchTabVC.view.frame = bodyView.bounds
        searchTabVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        searchTabVC.didMove(toParent: self)
    }
}

extension SearchViewController {
    private func bind() {
        let likedCoinID = PublishRelay<String>()
        let reloadDataTrigger = PublishRelay<Void>()
        let networkRetryTrigger = PublishRelay<Void>()
        let input = SearchViewModel.Input(likedCoinID: likedCoinID,
                                          reloadDataTrigger: reloadDataTrigger,
                                          returnButtonTapped: navigationBar.textField.rx.controlEvent(.editingDidEndOnExit),
                                          searchText: navigationBar.textField.rx.text,
                                          selectedCoin: searchTabVC.coinSearchViewController.collectionView.rx.modelSelected(SearchCoin.self), networkRetryTrigger: networkRetryTrigger)
        let output = viewModel.transform(input: input)
        
        output.setUITrigger
            .bind(with: self) { owner, text in
                owner.setNavigationTextField(text)
            }
            .disposed(by: disposeBag)
        
        output.showIndicatorTrigger
            .drive(with: self) { owner, isShow in
                if isShow {
                    owner.showIndicator()
                } else {
                    owner.hideIndicator()
                }
            }
            .disposed(by: disposeBag)
        
        output.searchCoinData
            .drive(searchTabVC.coinSearchViewController.collectionView.rx.items(cellIdentifier: SearchCoinCollectionViewCell.identifier, cellType: SearchCoinCollectionViewCell.self)) { _, element, cell in
                cell.setContent(element)
                cell.starButton.rx.tap
                    .bind() { _ in
                        likedCoinID.accept(element.id)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.collectionHiddenTrigger
            .drive(with: self) { owner, isHidden in
                owner.searchTabVC.coinSearchViewController.hideCollectionView(isHidden)
            }
            .disposed(by: disposeBag)
        
        output.pushDetailTrigger
            .bind(with: self) { owner, coinInfo in
                let vc = DetailViewController(coinInfo)
                vc.onUpdate = {
                    reloadDataTrigger.accept(())
                }
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.dialogTrigger
            .drive(with: self) { owner, message in
                guard let message else { return }
                owner.showDialog(message: message) {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.monitorDialogTrigger
            .drive(with: self) { owner, _ in
                owner.showMonitorDialog {
                    networkRetryTrigger.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        output.toastTrigger
            .bind(with: self) { owner, message in
                owner.showToast(message)
            }
            .disposed(by: disposeBag)
        
        output.networkToastTrigger
            .bind(with: self) { owner, _ in
                owner.showToastOnPresentView()
            }
            .disposed(by: disposeBag)
    }
}
