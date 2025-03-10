//
//  CoinSearchViewController.swift
//  BitLery
//
//  Created by 정인선 on 3/7/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class CoinSearchViewController: BaseViewController {
    private let emptyLabel = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: BaseCollectionViewCell.horizontalCell())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func configureHierarchy() {
        view.addSubview(emptyLabel)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        emptyLabel.text = "검색 결과가 없습니다."
        emptyLabel.font = Resource.SystemFont.regular12
        emptyLabel.textColor = .labelSecondary
    }
}

extension CoinSearchViewController {
    private func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SearchCoinCollectionViewCell.self, forCellWithReuseIdentifier: SearchCoinCollectionViewCell.identifier)
    }
}

extension CoinSearchViewController {
    func hideCollectionView(_ isHidden: Bool) {
        collectionView.isHidden = isHidden
    }
}
