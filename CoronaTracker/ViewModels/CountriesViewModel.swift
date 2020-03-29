
import Foundation

@objc protocol CountriesViewModelDelegate {
    func fetchCountriesCompleted()
}

class CountriesViewModel {
    var data = VirusDataModel([])
    var groupByCountry: Bool = true
    private var apiService: ApiService
    weak var delegate: CountriesViewModelDelegate?
    
    init(apiService: ApiService, groupByCountry: Bool) {
        self.apiService = apiService
        self.groupByCountry = groupByCountry
    }
    
    func fetchCountries() {
        apiService.getReports(groupByCountry: groupByCountry) { [weak self] (report) in
            let data = report.features.map { (feature) -> (String, CountryData) in
                return (feature.attributes.countryRegion,
                        CountryData(confirmed: feature.attributes.confirmed, cured: feature.attributes.recovered, death: feature.attributes.deaths, suspected: 0, lat: feature.attributes.lat, lng: feature.attributes.long))
            }
            DispatchQueue.main.async {
                self?.data = VirusDataModel(data)
                self?.delegate?.fetchCountriesCompleted()
            }
        }
        
    }
    
}
