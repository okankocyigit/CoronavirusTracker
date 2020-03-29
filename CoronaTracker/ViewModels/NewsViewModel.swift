
import Foundation

@objc protocol NewsViewModelDelegate {
    func fetchCompleted()
}
class NewsViewModel {
    var feeds: [NewsFeedModel] = []
    weak var delegate: NewsViewModelDelegate?
    
    func fetchNews() {
        var parameters = ""
        let keyword = "\("corona_search_keyword".localized().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            if countryCode == "CN" && Locale.current.languageCode == "zh" {
                parameters = "&hl=zh-CN&gl=CN&ceid=CN:zh-Hans"
            }
        }
        guard let url = URL(string: "https://news.google.com/rss/search?q=\(keyword)\(parameters)") else {return }
        let myParser : XmlParserManager = XmlParserManager().initWithURL(url) as! XmlParserManager
        
        feeds = myParser.allFeeds()
        delegate?.fetchCompleted()
    }
}
