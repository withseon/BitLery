//
//  BaseViewController.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import UIKit

class BaseViewController: UIViewController {
    let navigationBar = CustomNavigationBar()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        configureNavigation()
        configureUI()
    }
    
    private func configureUI() {
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() { }
    func configureNavigation() {
        navigationController?.navigationBar.isHidden = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseViewController {
    func setNavigationLargeTitle(_ text: String) {
        navigationBar.largeTitleLabel.isHidden = false
        navigationBar.largeTitleLabel.text = text
    }
    
    func setNavigationTextField(_ text: String) {
        navigationBar.leftButton.isHidden = false
        navigationBar.textField.isHidden = false
        navigationBar.textField.text = text
    }
    
    func setNavigationTitle(text: String, image: String) {
        navigationBar.leftButton.isHidden = false
        navigationBar.rightButton.isHidden = false
        navigationBar.titleView.isHidden = false
        navigationBar.titleLabel.text = text
        navigationBar.logoImageView.setKFImage(strURL: image)
    }
}

extension BaseViewController {
    func showDialog(message: String, buttonTitle: String) {
        let vc = DialogViewController(message: message, buttonTitle: buttonTitle)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}
