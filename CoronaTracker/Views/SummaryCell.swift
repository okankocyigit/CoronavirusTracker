
import Foundation
import UIKit
import Charts

class SummaryCell: UITableViewCell {
    static let identifier = "SummaryCell"
    var summaryData: SummaryData? {
        didSet {
            guard let data = summaryData else {return }
            summaryChartView.configure(data)
            deathRateChartView.configure(CGFloat(data.death)/CGFloat(data.confirmed))
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var summaryChartView: SummaryChartView = {
        let pieChart = SummaryChartView()
        return pieChart
    }()
    
    lazy var deathRateChartView: RateChartView = {
        let pieChart = RateChartView(value: 0)
        return pieChart
    }()
    
    func setupViews() {
        backgroundColor = .clear
        addSubview(summaryChartView)
        addSubview(deathRateChartView)
        
        summaryChartView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(200)
        }
        
        deathRateChartView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(200)
        }
    }
}
