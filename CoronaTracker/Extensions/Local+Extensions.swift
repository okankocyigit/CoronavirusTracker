
import Foundation

extension Locale {
    func isoCode(for countryName: String) -> String? {
        return Locale.isoRegionCodes.first(where: { (code) -> Bool in
            localizedString(forRegionCode: code)?.compare(countryName, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        })
    }
    
    func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            return name
        } else {
            return countryCode
        }
    }
}
