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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: BaseCollectionViewCell.horizontalCell())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension CoinSearchViewController {
    private func configureCollectionView() {
        collectionView.register(SearchCoinCollectionViewCell.self, forCellWithReuseIdentifier: SearchCoinCollectionViewCell.identifier)
    }
}
