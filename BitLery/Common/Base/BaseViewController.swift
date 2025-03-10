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
    var toastStyle = ToastStyle()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        toastStyle.backgroundColor = .labelSecondary
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

    func showIndicator() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow })
            else { return }

            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.backgroundColor = .systemBackground.withAlphaComponent(0.2)
                loadingIndicatorView.color = .blue
                window.addSubview(loadingIndicatorView)
            }

            loadingIndicatorView.startAnimating()
        }

    }
    
    func hideIndicator() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow })
            else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }

    }
}
