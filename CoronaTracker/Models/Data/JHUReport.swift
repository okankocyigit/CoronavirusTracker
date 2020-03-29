
import Foundation

struct JHUReport: Codable {
    let features: [Feature]
    
    enum CodingKeys: String, CodingKey {
        case features
    }
}

struct Feature: Codable {
    let attributes: Attributes
}

struct Attributes: Codable {
    let provinceState: String?
    let countryRegion: String
    let lastUpdate: Int
    let lat, long: Double
    let confirmed, recovered, deaths: Int
    
    enum CodingKeys: String, CodingKey {
        case provinceState = "Province_State"
        case countryRegion = "Country_Region"
        case lastUpdate = "Last_Update"
        case lat = "Lat"
        case long = "Long_"
        case confirmed = "Confirmed"
        case recovered = "Recovered"
        case deaths = "Deaths"
    }
}
