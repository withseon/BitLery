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
    private var TabVC = SearchPagingViewController()
    
    private let disposeBag = DisposeBag()
    private let viewModel: SearchViewModel
    
    init(_ text: String) {
        viewModel = SearchViewModel(text)
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
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
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SearchViewController {
    private func configureTabView() {
        addChild(TabVC)
        bodyView.addSubview(TabVC.view)
        TabVC.view.frame = bodyView.bounds
        TabVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        TabVC.didMove(toParent: self)
    }
}

extension SearchViewController {
    private func bind() {
        let input = SearchViewModel.Input(leftButtonTapped: navigationBar.leftButton.rx.tap,
                                          returnButtonTapped: navigationBar.textField.rx.controlEvent(.editingDidEndOnExit),
                                          searchText: navigationBar.textField.rx.text,
                                          selectedCoin: TabVC.coinSearchViewController.collectionView.rx.modelSelected(SearchCoin.self))
        let output = viewModel.transform(input: input)
        
        output.setUITrigger
            .bind(with: self) { owner, text in
                owner.configureTabView()
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
        
        output.popTrigger
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.searchCoinData
            .drive(TabVC.coinSearchViewController.collectionView.rx.items(cellIdentifier: SearchCoinCollectionViewCell.identifier, cellType: SearchCoinCollectionViewCell.self)) { _, element, cell in
                cell.setContent(element)
            }
            .disposed(by: disposeBag)
        
        output.collectionHiddenTrigger
            .drive(with: self) { owner, isHidden in
                owner.TabVC.coinSearchViewController.hideCollectionView(isHidden)
            }
            .disposed(by: disposeBag)
        
        output.pushDetailTrigger
            .bind(with: self) { owner, coinInfo in
                let vc = DetailViewController(coinInfo)
                owner.navigationController?.pushViewController(vc, animated: true)
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
