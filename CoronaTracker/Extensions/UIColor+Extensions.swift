
import Foundation
import UIKit

private struct Color {
    static let charcoal = 0x333347
    static let hotPink = 0xFF00BF
    static let hotPinkDark = 0xCF00B2
    static let mulberry = 0x352384
    static let mulberryDark = 0x2A025D
    static let whiteDark = 0xF3F3F5
    static let pastelOrange = 0xffb347
    static let pastelLightBlue = 0x222842
    static let pastelRed = 0xff6961
    static let pastelGreen = 0x77dd77
    static let pastelBlue = 0x1c223a
}

extension UIColor {
    
    convenience init(rgbValue: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func toImage(width: CGFloat = 2, height: CGFloat = 2) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        defer { UIGraphicsEndImageContext() }
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(self.cgColor)
            context.fill(rect)
        }
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
    static func pastelOrange() -> UIColor {
        return UIColor(rgbValue: Color.pastelOrange)
    }
    
    static func pastelGreen() -> UIColor {
        return UIColor(rgbValue: Color.pastelGreen)
    }
    
    static func pastelRed() -> UIColor {
        return UIColor(rgbValue: Color.pastelRed)
    }
    
    static func pastelLightBlue() -> UIColor {
        return UIColor(rgbValue: Color.pastelLightBlue)
    }
    
    static func pastelBlue() -> UIColor {
        return UIColor(rgbValue: Color.pastelBlue)
    }
}
