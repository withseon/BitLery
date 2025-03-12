//
//  MarketViewController.swift
//  BitLery
//
//  Created by 정인선 on 3/6/25.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class MarketViewController: BaseViewController {
    private let sortBackgroundView = UIView()
    private let marketLabel = UILabel()
    private let tradePriceSort = SortView("현재가")
    private let changedRateSort = SortView("전일대비")
    private let accPriceSort = SortView("거래대금")
    private let tradePriceSortButton = UIButton()
    private let changedRateSortButton = UIButton()
    private let accPriceSortButton = UIButton()
    private let marketCollectionView = UICollectionView(frame: .zero,
                                                        collectionViewLayout: BaseCollectionViewCell.horizontalCell())
    
    private let disposeBag = DisposeBag()
    private let viewModel = MarketViewModel()
    private let isTimerRunning = BehaviorRelay(value: true)
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        isTimerRunning.accept(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isTimerRunning.accept(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bind()
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        setNavigationLargeTitle("거래소")
    }
    
    override func configureHierarchy() {
        [navigationBar, sortBackgroundView, marketCollectionView].forEach { view in
            self.view.addSubview(view)
        }
        [marketLabel, tradePriceSort, changedRateSort, accPriceSort,
         tradePriceSortButton, changedRateSortButton, accPriceSortButton].forEach { view in
            sortBackgroundView.addSubview(view)
        }
    }
    
    override func configureLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        sortBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
        marketLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        tradePriceSort.snp.makeConstraints { make in
            make.leading.equalTo(marketLabel.snp.trailing)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        changedRateSort.snp.makeConstraints { make in
            make.leading.equalTo(tradePriceSort.snp.trailing)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        accPriceSort.snp.makeConstraints { make in
            make.leading.equalTo(changedRateSort.snp.trailing)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
        tradePriceSortButton.snp.makeConstraints { make in
            make.edges.equalTo(tradePriceSort)
        }
        changedRateSortButton.snp.makeConstraints { make in
            make.edges.equalTo(changedRateSort)
        }
        accPriceSortButton.snp.makeConstraints { make in
            make.edges.equalTo(accPriceSort)
        }
        marketCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sortBackgroundView.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        sortBackgroundView.backgroundColor = .backgroundSecondary
        
        marketLabel.text = "코인"
        marketLabel.font = Resource.SystemFont.bold12
        marketLabel.textColor = .labelMain
        marketLabel.textAlignment = .left
    }
}

// MARK: - 컬렉션 뷰
extension MarketViewController {
    private func configureCollectionView() {
        marketCollectionView.register(MarketCollectionViewCell.self,
                                      forCellWithReuseIdentifier: MarketCollectionViewCell.identifier)
    }
}

// MARK: - bind 메서드
extension MarketViewController {
    private func bind() {
        let viewDidLoadTrigger = PublishRelay<Void>()
        let networkRetryTrigger = PublishRelay<Void>()
        let dismissDialogTrigger = PublishRelay<Void>()
        let input = MarketViewModel.Input(viewDidLoadTrigger: viewDidLoadTrigger,
                                          isTimerRunning: isTimerRunning,
                                          tradePriceButtonTapped: tradePriceSortButton.rx.tap,
                                          rateButtonTapped: changedRateSortButton.rx.tap,
                                          accPriceButtonTapped: accPriceSortButton.rx.tap,
                                          networkRetryTrigger: networkRetryTrigger,
                                          dismissDialogTrigger: dismissDialogTrigger)
        let output = viewModel.transform(input: input)
        
        output.showIndicatorTrigger
            .drive(with: self) { owner, isShow in
                if isShow {
                    owner.showIndicator()
                } else {
                    owner.hideIndicator()
                }
            }
            .disposed(by: disposeBag)
        
        output.tickerData
            .drive(
                marketCollectionView
                    .rx
                    .items(
                        cellIdentifier: MarketCollectionViewCell.identifier,
                        cellType: MarketCollectionViewCell.self
                    )
            ) { _, element, cell in
                cell.setContent(element)
            }
            .disposed(by: disposeBag)
        
        output.changeTradePriceButton
            .drive(with: self) { owner, value in
                if value == 0 {
                    owner.tradePriceSort.setDefault()
                } else if value == 1 {
                    owner.tradePriceSort.setAsc()
                } else {
                    owner.tradePriceSort.setDesc()
                }
            }
            .disposed(by: disposeBag)
        
        output.changeRateButton
            .drive(with: self) { owner, value in
                if value == 0 {
                    owner.changedRateSort.setDefault()
                } else if value == 1 {
                    owner.changedRateSort.setAsc()
                } else {
                    owner.changedRateSort.setDesc()
                }
            }
            .disposed(by: disposeBag)
        
        output.changeAccPriceButton
            .drive(with: self) { owner, value in
                if value == 0 {
                    owner.accPriceSort.setDefault()
                } else if value == 1 {
                    owner.accPriceSort.setAsc()
                } else {
                    owner.accPriceSort.setDesc()
                }
            }
            .disposed(by: disposeBag)
        
        output.dialogTrigger
            .drive(with: self) { owner, message in
                guard let message else { return }
                owner.showDialog(message: message)
                dismissDialogTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        output.monitorDialogTrigger
            .drive(with: self) { owner, _ in
                owner.showMonitorDialog {
                    networkRetryTrigger.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        output.toastTrigger
            .bind(with: self) { owner, _ in
                owner.showToastOnPresentView()
            }
            .disposed(by: disposeBag)
        
        viewDidLoadTrigger.accept(())
    }
}
