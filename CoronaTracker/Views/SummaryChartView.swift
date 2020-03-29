
import Foundation
import Charts

class SummaryChartView: PieChartView {
    
    var entries: [PieChartDataEntry] = []
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .init(x: 0, y: 0, width: 200, height: 200))
    }
    
    func configure(_ summaryData: SummaryData) {
        self.delegate = self
        self.centerText = ""
        self.usePercentValuesEnabled = true
        self.rotationEnabled = false
        self.drawEntryLabelsEnabled = false
        self.holeColor = .clear
        
        entries = [
            PieChartDataEntry.init(value: Double(summaryData.confirmed), label: "confirmed".localized()),
            PieChartDataEntry.init(value: Double(summaryData.cured), label: "cured".localized()),
            PieChartDataEntry.init(value: Double(summaryData.death), label: "death".localized()),
            PieChartDataEntry.init(value: Double(summaryData.suspected), label: "suspected".localized())
        ]
        
        setCenterText(entry: entries[0])
        
        let pieChartDataSet = PieChartDataSet(entries: entries)
        
        pieChartDataSet.colors =  [.pastelOrange(), .pastelGreen(), .pastelRed(), .yellow]
        pieChartDataSet.valueTextColor = .black
        pieChartDataSet.drawValuesEnabled = false
        pieChartDataSet.drawIconsEnabled = false
        pieChartDataSet.sliceSpace = 2.5
        self.legend.enabled = false
        self.holeRadiusPercent = 0.8
        self.data = PieChartData(dataSet: pieChartDataSet)
        self.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
    }
    
    private func setCenterText(entry: PieChartDataEntry) {
        guard entry.value > 0 else {return}
        let mutableString = NSMutableAttributedString()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        mutableString.append(
            NSAttributedString(string: "\(Int(entry.value).toformat())\n",
                attributes: [
                    .foregroundColor : UIColor.white,
                    .font: UIFont.boldSystemFont(ofSize: 16),
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

extension SummaryChartView: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let entry = entry as? PieChartDataEntry else {
            return
        }
        
        setCenterText(entry: entry)
    }
    
    func chartView(_ chartView: ChartViewBase, animatorDidStop animator: Animator) {
        self.highlightValue(Highlight.init(x: 0, dataSetIndex: 0, stackIndex: 0))
    }
    
}
