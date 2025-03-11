//
//  SearchPagingViewController.swift
//  BitLery
//
//  Created by 정인선 on 3/9/25.
//

import UIKit
import Tabman
import Pageboy
import SnapKit

final class SearchTabViewController: TabmanViewController {
    let coinSearchViewController = CoinSearchViewController()
    private var viewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nftSearchViewController = NFTSearchViewController()
        let marketSearchViewController = MarketSearchViewController()
        
        viewControllers.append(coinSearchViewController)
        viewControllers.append(nftSearchViewController)
        viewControllers.append(marketSearchViewController)

        configureTabBar()
    }
}

extension SearchTabViewController {
    private func configureTabBar() {
        let underLineView = UIView()
        let underLine = UIView()
        underLineView.addSubview(underLine)
        underLine.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        underLine.backgroundColor = .labelSecondary
        
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .custom(view: underLineView)
        bar.backgroundColor = .systemBackground
        
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = .labelMain
        bar.indicator.overscrollBehavior = .bounce
        
        bar.buttons.customize { button in
            button.tintColor = .labelSecondary
            button.selectedTintColor = .labelMain
            button.font = Resource.SystemFont.bold14
        }
        
        addBar(bar, dataSource: self, at: .top)
        dataSource = self
    }
}

extension SearchTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return .first
    }
    
    func barItem(for bar: any TMBar, at index: Int) -> any TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "코인")
        case 1:
            return TMBarItem(title: "NFT")
        case 2:
            return TMBarItem(title: "거래소")
        default:
            return TMBarItem(title: "Unknown")
        }
    }
}
