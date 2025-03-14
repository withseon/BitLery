//
//  BaseViewController.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import UIKit
import Toast

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
        setLeftButton()
        navigationBar.textField.isHidden = false
        navigationBar.textField.text = text
    }
    
    func setNavigationTitle(text: String, image: String) {
        setLeftButton()
        navigationBar.rightButton.isHidden = false
        navigationBar.titleView.isHidden = false
        navigationBar.titleLabel.text = text
        navigationBar.logoImageView.setKFImage(strURL: image)
    }
    
    private func setLeftButton() {
        navigationBar.leftButton.isHidden = false
        navigationBar.leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func leftButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension BaseViewController {
    func showDialog(message: String, buttonTitle: String = "확인", dismissAction: (() -> Void)?, conformAction: (() -> Void)? = nil) {
        let vc = DialogViewController(message: message, buttonTitle: buttonTitle)
        vc.confirmHandler = conformAction
        vc.dismissHandler = dismissAction
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    func showMonitorDialog(dismissAction: (() -> Void)? = nil, conformAction: (() -> Void)? = nil) {
        let message = "네트워크 연결이 일시적으로 원활하지 않습니다. 데이터 또는 Wi-Fi 연결 상태를 확인해주세요."
        let buttonTitle = "다시 시도하기"
        showDialog(message: message, buttonTitle: buttonTitle, dismissAction: dismissAction, conformAction: conformAction)
    }
    
    func showIndicator() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        
        let loadingIndicatorView: UIActivityIndicatorView
        if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
            loadingIndicatorView = existedView
        } else {
            loadingIndicatorView = UIActivityIndicatorView(style: .large)
            loadingIndicatorView.frame = window.frame
            loadingIndicatorView.backgroundColor = .systemBackground.withAlphaComponent(0.2)
            loadingIndicatorView.color = .labelSecondary
            window.addSubview(loadingIndicatorView)
        }
        
        loadingIndicatorView.startAnimating()
    }
    
    func hideIndicator() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow })
        else { return }
        window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
    }
    
    func showToast(_ text: String) {
        var toastStyle = ToastStyle()
        toastStyle.backgroundColor = .labelMain
        view.makeToast(text, duration: 2, style: toastStyle)
    }
    
    func showToastOnPresentView() {
        guard let presentedViewController = self.presentedViewController else { return }
        let message = "네트워크 통신이 원활하지 않습니다"
        var toastStyle = ToastStyle()
        toastStyle.backgroundColor = .labelMain
        presentedViewController.view.makeToast(message, duration: 2, style: toastStyle)
    }
}
