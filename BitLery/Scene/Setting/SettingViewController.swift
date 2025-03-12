//
//  SettingViewController.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class SettingViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigation() {
        super.configureNavigation()
    }
    
    override func configureHierarchy() {
        view.addSubview(navigationBar)
    }
    
    override func configureLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        
    }

}
