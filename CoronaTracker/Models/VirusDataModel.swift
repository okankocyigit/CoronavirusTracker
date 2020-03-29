
import Foundation
import  UIKit

class VirusDataModel {
    var data: [(String, CountryData)]
    var minConfirmed: Int = 0
    var maxConfirmed: Int = 0
    
    init(_ data: [(String, CountryData)]) {
        self.data = data.sorted(by: { (key1, key2) -> Bool in
            return key1.1.confirmed > key2.1.confirmed
        })
        let values = self.data.map { (name, value) -> Int in
            return value.confirmed
        }
        
        self.minConfirmed = values.min() ?? 0
        self.maxConfirmed = values.max() ?? 0
    }
    
    var countries: [String] {
        return [String](data.map { $0.0 })
    }
    
    func getConfirmedRangeValue(_ countryName: String) -> CGFloat {
        guard let countryData = data.first(where: { (name, value) -> Bool in
            return name == countryName
        }) else { return 0 }
        return CGFloat(countryData.1.confirmed - self.minConfirmed)/CGFloat(self.maxConfirmed-self.minConfirmed)
    }
}
