
import Foundation

extension Int {
    func toformat() -> String {
        let styler = NumberFormatter()
        styler.numberStyle = .decimal
        styler.groupingSeparator = "."
        return styler.string(for: self) ?? "\(self)"
    }
}
