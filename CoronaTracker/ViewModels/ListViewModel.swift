
import Foundation

class ListViewModel {
    var summaryViewModel: SummaryViewModel
    var countriesViewModel: CountriesViewModel
    init(apiService: ApiService) {
        summaryViewModel = SummaryViewModel(apiService: apiService)
        countriesViewModel = CountriesViewModel(apiService: apiService, groupByCountry: true)
    }
}
