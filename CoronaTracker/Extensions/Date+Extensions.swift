
import Foundation

class DateHelper {
    
    static func getLocaleDateString(from timeSpan: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeSpan)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
    
    static func getLocalRelativeDateString(from timeSpan: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeSpan)
        if #available(iOS 13.0, *) {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            let relativeDate = formatter.localizedString(for: date, relativeTo: Date())
            return relativeDate
        } else {
            return getLocaleDateString(from: timeSpan)
        }
    }
}
