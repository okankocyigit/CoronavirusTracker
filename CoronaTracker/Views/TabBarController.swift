
import Foundation
import UIKit
import SnapKit
import Localize_Swift
import SafariServices

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupControllers()
    }
    
    func configure() {
        tabBar.barTintColor = UIColor.init(rgbValue: 0x1c223a)
        tabBarItem.badgeColor = UIColor.init(rgbValue: 0x7D9DFF)
        tabBar.tintColor = UIColor.init(rgbValue: 0x7D9DFF)
        tabBar.isTranslucent = false
        let view = UIView()
        view.backgroundColor = .init(rgbValue: 0x222842)
        
        tabBar.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.height.equalTo(3)
            make.width.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    func setupControllers() {
        let apiService = JHUService()
        let mapViewController = MapViewController(apiService: apiService)
        
        mapViewController.tabBarItem.title = "Map".localized()
        mapViewController.tabBarItem.image = UIImage(named: "map-icon")
        
        let newsViewController = NewsViewController()
        newsViewController.tabBarItem.title = "News".localized()
        newsViewController.tabBarItem.image = UIImage(named: "rss")
        
        let listViewController = ListViewController(apiService: apiService)
        listViewController.tabBarItem.title = "Countries".localized()
        listViewController.tabBarItem.image = UIImage(named: "list-icon")
        
        viewControllers = [listViewController, mapViewController, newsViewController]
    }
    
}
