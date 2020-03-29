
import Foundation

class XmlParserManager: NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var img:  [AnyObject] = []
    var fdescription = NSMutableString()
    var fdate = NSMutableString()
    var source = NSMutableString()
    
    func initWithURL(_ url :URL) -> AnyObject {
        startParse(url)
        return self
    }
    
    func startParse(_ url :URL) {
        self.feeds = []
        self.parser = XMLParser(contentsOf: url)!
        self.parser.delegate = self
        self.parser.shouldProcessNamespaces = false
        self.parser.shouldReportNamespacePrefixes = false
        self.parser.shouldResolveExternalEntities = false
        self.parser.parse()
    }
    
    func allFeeds() -> [NewsFeedModel] {
        return self.feeds.map { (item) -> NewsFeedModel in
            let itemObject = item as AnyObject
            let title = itemObject.object(forKey: "title") as? String
            let link = itemObject.object(forKey: "link") as? String
            let source = itemObject.object(forKey: "source") as? String
            let pubDate = itemObject.object(forKey: "pubDate") as? String
            return NewsFeedModel(title: title, link: link, pubDate: pubDate, source: source)
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.element = elementName as NSString
        if (self.element as NSString).isEqual(to: "item") {
            self.elements =  NSMutableDictionary()
            self.elements = [:]
            self.ftitle = NSMutableString()
            self.ftitle = ""
            self.link = NSMutableString()
            self.link = ""
            self.fdescription = NSMutableString()
            self.fdescription = ""
            self.fdate = NSMutableString()
            self.fdate = ""
            self.source = NSMutableString()
            self.source = ""
        } else if (self.element as NSString).isEqual(to: "enclosure") {
            if let urlString = attributeDict["url"] {
                self.img.append(urlString as AnyObject)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if (elementName as NSString).isEqual(to: "item") {
            if self.ftitle != "" {
                self.elements.setObject(self.ftitle, forKey: "title" as NSCopying)
            }
            if self.link != "" {
                self.elements.setObject(self.link, forKey: "link" as NSCopying)
            }
            if self.fdescription != "" {
                self.elements.setObject(self.fdescription, forKey: "description" as NSCopying)
            }
            if self.fdate != "" {
                self.elements.setObject(self.fdate, forKey: "pubDate" as NSCopying)
            }
            
            if self.source != "" {
                self.elements.setObject(self.source, forKey: "source" as NSCopying)
            }
            self.feeds.add(self.elements)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.element.isEqual(to: "title") {
            self.ftitle.append(string)
        } else if element.isEqual(to: "link") {
            self.link.append(string)
        } else if element.isEqual(to: "description") {
            self.fdescription.append(string)
        } else if element.isEqual(to: "pubDate") {
            self.fdate.append(string)
        } else if element.isEqual(to: "source") {
            self.source.append(string)
        }
    }
}
