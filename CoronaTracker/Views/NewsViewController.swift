
import Foundation
import SwiftWebVC
import NVActivityIndicatorView

class NewsViewController: UITableViewController {
    var workItem: DispatchWorkItem?
    var viewModel = NewsViewModel()
    
    lazy var activityIndicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 50) , type: NVActivityIndicatorType.ballPulseSync, color: UIColor.lightText, padding: 0)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
            self?.viewModel.fetchNews()
        }
        
        refreshControl = UIRefreshControl()
        resetRefreshControlText()
        refreshControl?.tintColor = .lightText
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    @objc func refresh() {
        workItem?.cancel()
        refreshControl?.attributedTitle = NSAttributedString(string: "refreshing".localized(), attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightText])
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
            self?.viewModel.fetchNews()
        }
    }
    
    func stopRefreshControl() {
        if refreshControl?.isRefreshing == true {
            refreshControl?.endRefreshing()
        }
        workItem = DispatchWorkItem { self.resetRefreshControlText() }
        if let workItem = self.workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        }
    }
    
    func resetRefreshControlText() {
        self.refreshControl?.attributedTitle = NSAttributedString(string: "pull_down_to_refresh".localized(), attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightText])
    }
    
    func setupViews() {
        self.view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        activityIndicator.startAnimating()
        view.backgroundColor = .pastelBlue()
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.register(NewsViewCell.self, forCellReuseIdentifier: NewsViewCell.identifier)
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.setTitle("Corona Tracker".localized(), subtitle: "News".localized())
    }
    
}

extension NewsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsViewCell.identifier, for: indexPath) as! NewsViewCell
        
        let feed = viewModel.feeds[indexPath.row]
        cell.data = feed
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let url = viewModel.feeds[indexPath.row].link else {return}
        
        let webVC = SwiftModalWebVC(urlString: url , theme: .lightBlack, dismissButtonStyle: .cross, sharingEnabled: true)
        self.present(webVC, animated: true) {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension NewsViewController: NewsViewModelDelegate {
    func fetchCompleted() {
        activityIndicator.stopAnimating()
        stopRefreshControl()
        tableView.reloadData()
    }
}
