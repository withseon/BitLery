//
//  MainViewController.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
    }
}

// MARK: - TabItem 리소스
extension MainTabBarController {
    enum TabItem: CaseIterable {
        case market
        case rank
        case setting
        
        var title: String {
            switch self {
            case .market:
                return "거래소"
            case .rank:
                return "코인정보"
            case .setting:
                return "포트폴리오"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .market:
                return UIImage(systemName: "chart.line.uptrend.xyaxis")
            case .rank:
                return UIImage(systemName: "chart.bar.fill")
            case .setting:
                return UIImage(systemName: "star")
            }
        }
        
        var vc: UIViewController.Type {
            switch self {
            case .market:
                return MarketViewController.self
            case .rank:
                return RankViewController.self
            case .setting:
                return SettingViewController.self
            }
        }
    }

}

// MARK: - TabBar 설정
extension MainTabBarController {
    private func configureTabBarController() {
        let viewControllers = TabItem.allCases.map { tabItem in
            let nav = UINavigationController(rootViewController: tabItem.vc.init())
            nav.tabBarItem.image = tabItem.image
            nav.title = tabItem.title
            return nav
        }
        setViewControllers(viewControllers, animated: true)
    }
}
