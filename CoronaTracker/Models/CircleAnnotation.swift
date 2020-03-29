
import Foundation
import UIKit
import MapKit

class CircleAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var name: String?
    var data: CountryData?
    var status: Status?
    
    init(coordinate: CLLocationCoordinate2D, name: String, data: CountryData, status: Status) {
        self.coordinate = coordinate
        self.data = data
        self.name = name
        self.status = status
    }
}
