//
//  DetailViewController.swift
//  BitLery
//
//  Created by 정인선 on 3/7/25.
//

import UIKit
import DGCharts
import RxCocoa
import RxSwift
import SnapKit

final class DetailViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let currentPriceLabel = UILabel()
    private let rateView = RateView()
    private let chartView = LineChartView()
    private let updateLabel = UILabel()
    private let infoTitleLabel = TitleLabel("종목정보")
    private let infoMoreButton = MoreButton()
    private let infoBackgroundView = UIView()
    private let priceView = UIView()
    private let highPriceInfoView = DetailInfoView("24시간 고가")
    private let lowPriceInfoView = DetailInfoView("24시간 저가")
    private let atPriceView = UIView()
    private let atHighPriceInfoView = DetailInfoView("역대 최고가")
    private let atLowPriceInfoView = DetailInfoView("역대 최저가")
    private let volumeTitleLabel = TitleLabel("투자지표")
    private let volumeMoreButton = MoreButton()
    private let volumeBackgroundView = UIView()
    private let marketCapInfoView = DetailInfoView("시가총액")
    private let valuationInfoView = DetailInfoView("완전 희석 가치(FDV)")
    private let totalVolumeInfoView = DetailInfoView("총 거래량")
    
    private let disposeBag = DisposeBag()
    private let viewModel: DetailViewModel
    
    init(_ coinInfo: CoinBasicInfo) {
        viewModel = DetailViewModel(coinInfo)
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureHierarchy() {
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [currentPriceLabel, rateView, chartView, updateLabel,
         infoTitleLabel, infoMoreButton, infoBackgroundView,
         priceView, atPriceView,
         volumeTitleLabel, volumeMoreButton, volumeBackgroundView,
         marketCapInfoView, valuationInfoView, totalVolumeInfoView].forEach { view in
            contentView.addSubview(view)
        }
        priceView.addSubview(highPriceInfoView)
        priceView.addSubview(lowPriceInfoView)
        atPriceView.addSubview(atHighPriceInfoView)
        atPriceView.addSubview(atLowPriceInfoView)
    }
    
    override func configureLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        currentPriceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        rateView.snp.makeConstraints { make in
            make.top.equalTo(currentPriceLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(20)
        }
        chartView.snp.makeConstraints { make in
            make.top.equalTo(rateView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(200)
        }
        updateLabel.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(20)
        }
        infoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(updateLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        infoMoreButton.snp.makeConstraints { make in
            make.centerY.equalTo(infoTitleLabel)
            make.trailing.equalToSuperview().inset(20)
            make.leading.greaterThanOrEqualTo(infoTitleLabel.snp.trailing).offset(20)
        }
        infoBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(infoTitleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        priceView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(infoBackgroundView).inset(20)
        }
        highPriceInfoView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        lowPriceInfoView.snp.makeConstraints { make in
            make.leading.equalTo(highPriceInfoView.snp.trailing)
            make.verticalEdges.trailing.equalToSuperview()
        }
        atPriceView.snp.makeConstraints { make in
            make.top.equalTo(priceView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(infoBackgroundView).inset(20)
        }
        atHighPriceInfoView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        atLowPriceInfoView.snp.makeConstraints { make in
            make.leading.equalTo(atHighPriceInfoView.snp.trailing)
            make.verticalEdges.trailing.equalToSuperview()
        }
        volumeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(infoBackgroundView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        volumeMoreButton.snp.makeConstraints { make in
            make.centerY.equalTo(volumeTitleLabel)
            make.trailing.equalToSuperview().inset(20)
            make.leading.greaterThanOrEqualTo(volumeTitleLabel.snp.trailing).offset(20)
        }
        volumeBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(volumeTitleLabel.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalToSuperview().inset(20)
        }
        marketCapInfoView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(volumeBackgroundView).inset(20)
        }
        valuationInfoView.snp.makeConstraints { make in
            make.top.equalTo(marketCapInfoView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(volumeBackgroundView).inset(20)
        }
        totalVolumeInfoView.snp.makeConstraints { make in
            make.top.equalTo(valuationInfoView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(volumeBackgroundView).inset(20)
        }
    }
    
    override func configureView() {
        currentPriceLabel.font = Resource.SystemFont.heavy18
        updateLabel.font = Resource.SystemFont.regular9
        updateLabel.textColor = .labelSecondary
        updateLabel.textAlignment = .left
        infoBackgroundView.backgroundColor = .backgroundSecondary
        infoBackgroundView.clipsToBounds = true
        infoBackgroundView.layer.cornerRadius = 20
        volumeBackgroundView.backgroundColor = .backgroundSecondary
        volumeBackgroundView.clipsToBounds = true
        volumeBackgroundView.layer.cornerRadius = 20
    }
}

extension DetailViewController {
    private func bind() {
        let input = DetailViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.setUITrigger
            .bind(with: self) { owner, coinInfo in
                owner.setNavigationTitle(text: coinInfo.symbol, image: coinInfo.thumbImage)
            }
            .disposed(by: disposeBag)
        
        output.marketData
            .drive(with: self) { owner, coin in
                guard let coin else { return }
                owner.setContent(coin)
            }
            .disposed(by: disposeBag)
    }
}

extension DetailViewController {
    func setContent(_ coin: CoinMarket) {
        currentPriceLabel.text = coin.currentPrice
        rateView.setContent(coin.changeRatePrice)
        updateLabel.text = coin.lastUpdate
        highPriceInfoView.setContent(price: coin.highPrice24H)
        lowPriceInfoView.setContent(price: coin.lowPrice24H)
        atHighPriceInfoView.setContent(price: coin.atHighPrice, date: coin.atHighDate)
        atLowPriceInfoView.setContent(price: coin.atLowPrice, date: coin.atLowDate)
        marketCapInfoView.setContent(price: coin.marketCapPrice)
        valuationInfoView.setContent(price: coin.fullyDilutedValuation)
        totalVolumeInfoView.setContent(price: coin.totalVolume)
        setChart(coin.sparklinePrices)
    }
    
    func setChart(_ sparkline: [Double]) {
        // X축 설정
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawLabelsEnabled = false
        
        // 왼쪽 Y축 설정
        let leftAxis = chartView.leftAxis
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawLabelsEnabled = false
        
        // 오른쪽 Y축 설정
        chartView.rightAxis.enabled = false
        
        // MARK: UI와 비슷하게 구현하고자 data 중 일부만 차트 데이터로 사용
        var dataEntry = [ChartDataEntry]()
        let dataLastIndex = sparkline.count - 1
        for index in 0...dataLastIndex {
            if index % 3 == 0 || index == dataLastIndex {
                dataEntry.append(ChartDataEntry(x: Double(index), y: sparkline[index]))
            }
        }
        let dataSet = LineChartDataSet(entries: dataEntry)
        let chartData = LineChartData(dataSet: dataSet)
        chartView.data = chartData
        let gradientColors = [UIColor.labelDown.cgColor,
                              UIColor.labelDown.withAlphaComponent(0.1).cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors, locations: [0.5, 0.0])
        
        dataSet.lineWidth = 1.5
        dataSet.setColor(.labelDown)
        dataSet.drawCirclesEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90)
        dataSet.fillAlpha = 0.7
        dataSet.mode = .cubicBezier
        dataSet.cubicIntensity = 0.2
        dataSet.drawValuesEnabled = false
        
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        chartView.legend.enabled = false
        chartView.noDataText = "차트 데이터가 없습니다."
        chartView.highlightPerDragEnabled = false
        chartView.highlightPerTapEnabled = false
    }
}
