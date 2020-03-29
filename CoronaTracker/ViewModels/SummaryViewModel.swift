import Foundation

@objc protocol SummaryViewModelDelegate {
    func fetchSummaryCompleted()
}
class SummaryViewModel {
    var summaryData = SummaryData(confirmed: 0, cured: 0, death: 0, suspected: 0, updatedAt: "")
    private var apiService: ApiService
    weak var delegate: SummaryViewModelDelegate?
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func fetchSummary() {
        apiService.getReports(groupByCountry: true, completion: { [weak self] (report) in
            let confirmed = report.features.reduce(0) { $0 + $1.attributes.confirmed }
            let deaths = report.features.reduce(0) { $0 + $1.attributes.deaths }
            let cured = report.features.reduce(0) { $0 + $1.attributes.recovered }
            let lastupdate = report.features.map{ $0.attributes.lastUpdate }.max()
            
            var updatedAt = ""
            if let lastupdate = lastupdate {
                updatedAt = "\(lastupdate/1000)"
            }
            
            DispatchQueue.main.async {
                self?.summaryData = SummaryData(confirmed: confirmed, cured: cured, death: deaths, suspected: 0, updatedAt: updatedAt)
                self?.delegate?.fetchSummaryCompleted()
            }
        })
    }
    
}
