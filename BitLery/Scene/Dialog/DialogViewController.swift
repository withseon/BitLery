//
//  DialogViewController.swift
//  BitLery
//
//  Created by 정인선 on 3/8/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class DialogViewController: BaseViewController {
    private let backgroundView = UIView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let lineView = UIView()
    private let confirmLabel = UILabel()
    private let confirmButton = UIButton()
    
    private let disposeBag = DisposeBag()
    private let viewModel: DialogViewModel
    var confirmHandler: (() -> Void)?
    
    init(message: String, buttonTitle: String) {
        messageLabel.text = message
        confirmLabel.text = buttonTitle
        viewModel = DialogViewModel()
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureHierarchy() {
        [backgroundView, contentView].forEach { view in
            self.view.addSubview(view)
        }
        [titleLabel, messageLabel, lineView, confirmLabel, confirmButton].forEach { view in
            contentView.addSubview(view)
        }
    }
    
    override func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        confirmLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.bottom.horizontalEdges.equalToSuperview().inset(10)
        }
        confirmButton.snp.makeConstraints { make in
            make.edges.equalTo(confirmLabel)
        }
    }
    
    override func configureView() {
        view.backgroundColor = .clear
        
        backgroundView.backgroundColor = .black
        backgroundView.layer.opacity = 0.3
        
        contentView.backgroundColor = .systemBackground
        
        titleLabel.font = Resource.SystemFont.bold14
        titleLabel.textColor = .labelMain
        titleLabel.textAlignment = .center
        titleLabel.text = "안내"
        
        messageLabel.font = Resource.SystemFont.regular14
        messageLabel.textColor = .labelMain
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        lineView.backgroundColor = .backgroundSecondary
        
        confirmLabel.font = Resource.SystemFont.bold14
        confirmLabel.textColor = .labelMain
        confirmLabel.textAlignment = .center
    }
}

// MARK: - bind
extension DialogViewController {
    private func bind() {
        let input = DialogViewModel.Input(confirmButtonTapped: confirmButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.dismissTrigger
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
                owner.confirmHandler?()
            }
            .disposed(by: disposeBag)
        
        output.actionTrigger
            .bind(with: self) { owner, _ in
                owner.confirmHandler?()
            }
            .disposed(by: disposeBag)
    }
}
