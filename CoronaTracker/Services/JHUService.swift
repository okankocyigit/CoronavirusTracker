
import Foundation

protocol ApiService {
    func getReports(groupByCountry: Bool, completion: @escaping (JHUReport) -> ())
}

class JHUService: ApiService {
    let urlStringDetailed = "https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/1/query?f=json&where=Confirmed%20%3E%200&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Confirmed%20desc%2CCountry_Region%20asc%2CProvince_State%20asc&resultOffset=0&resultRecordCount=500&cacheHint=false&rnd=\(Int.random(in: 1..<Int.max))"
    
    let urlString = "https://services1.arcgis.com/0MSEUqKaxRlEPj5g/ArcGIS/rest/services/ncov_cases2_v1/FeatureServer/2/query?f=json&where=Confirmed%20%3E%200&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Confirmed%20desc&outSR=102100&resultOffset=0&resultRecordCount=200&cacheHint=true&rnd=\(Int.random(in: 1..<Int.max))"
    
    func getReports(groupByCountry: Bool, completion: @escaping (JHUReport) -> ()) {
        let url = URL(string: groupByCountry ? urlString : urlStringDetailed)!
        var request = URLRequest(url: url)
        request.setValue("https://www.arcgis.com/", forHTTPHeaderField: "Referer")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let report = try JSONDecoder().decode(JHUReport.self, from: data)
                completion(report)
            } catch (let error) {
                print(error)
            }
        }
        
        task.resume()
    }
}
