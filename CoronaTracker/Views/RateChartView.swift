
import Foundation
import Charts

class RateChartView: PieChartView {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(value: CGFloat) {
        super.init(frame: .init(x: 0, y: 0, width: 200, height: 200))
    }
    
    func configure(_ value: CGFloat) {
        self.centerText = ""
        self.usePercentValuesEnabled = true
        self.rotationEnabled = false
        self.isUserInteractionEnabled = false
        self.drawEntryLabelsEnabled = false
        self.holeColor = .clear
        
        let entries = [
            PieChartDataEntry.init(value: Double(value)*100, label: "Mortality Rate".localized()),
            PieChartDataEntry.init(value: Double(1 - value)*100, label: "")
        ]
        
        setCenterText(entry: entries[0])
        
        let pieChartDataSet = PieChartDataSet(entries: entries)
        
        pieChartDataSet.colors = [.pastelRed(), .pastelLightBlue()]
        pieChartDataSet.valueTextColor = .black
        pieChartDataSet.drawValuesEnabled = false
        pieChartDataSet.drawIconsEnabled = false
        pieChartDataSet.sliceSpace = 2.5
        self.legend.enabled = false
        self.holeRadiusPercent = 0.8
        self.data = PieChartData(dataSet: pieChartDataSet)
        self.highlightValue(Highlight(x: 0, dataSetIndex: 0, stackIndex: 0))
        self.animate(xAxisDuration: 1, yAxisDuration: 1)
    }
    
    private func setCenterText(entry: PieChartDataEntry) {
        guard !entry.value.isNaN else {return}
        
        let mutableString = NSMutableAttributedString()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        mutableString.append(
            NSAttributedString(string: "%",
                               attributes: [
                                .foregroundColor : UIColor.white,
                                .font: UIFont.boldSystemFont(ofSize: 12),
                                .paragraphStyle: paragraph
            ])
        )
        mutableString.append(
            NSAttributedString(string: "\(Int(entry.value))\n",
                attributes: [
                    .foregroundColor : UIColor.white,
                    .font: UIFont.boldSystemFont(ofSize: 20),
                    .paragraphStyle: paragraph
            ])
        )
        mutableString.append(
            NSAttributedString(string: entry.label!,
                               attributes: [
                                .foregroundColor : UIColor.lightText,
                                .font: UIFont.systemFont(ofSize: 12),
                                .paragraphStyle: paragraph
            ])
        )
        centerAttributedText = mutableString
    }
    
}
