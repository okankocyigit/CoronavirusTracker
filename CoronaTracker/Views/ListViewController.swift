
import UIKit
import MapKit
import Charts

class ListViewController: UITableViewController {
    
    var workItem: DispatchWorkItem?
    var viewModel: ListViewModel
    
    init(apiService: ApiService) {
        viewModel = ListViewModel(apiService: apiService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTitle()
    }
    
    private func setTitle() {
        var subTitle = ""
        if let timeStamp = Double(viewModel.summaryViewModel.summaryData.updatedAt) {
            let time = DateHelper.getLocalRelativeDateString(from: timeStamp)
            subTitle = "\("Last update".localized()): \(time)"
        }
        
        self.tabBarController?.navigationItem.setTitle("Corona Tracker".localized(), subtitle: subTitle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.countriesViewModel.fetchCountries()
        viewModel.summaryViewModel.fetchSummary()
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .lightText
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    @objc func refresh() {
        workItem?.cancel()
        refreshControl?.attributedTitle = NSAttributedString(string: "refreshing".localized(), attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightText])
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.viewModel.countriesViewModel.fetchCountries()
            self.viewModel.summaryViewModel.fetchSummary()
        }
    }
    
    func stopRefreshControl() {
        if refreshControl?.isRefreshing == true {
            refreshControl?.endRefreshing()
        }
        workItem = DispatchWorkItem { self.resetRefreshControlText() }
        if let workItem = self.workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
        }
    }
    
    func resetRefreshControlText() {
        self.refreshControl?.attributedTitle = NSAttributedString(string: "pull_down_to_refresh".localized(), attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightText])
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.init(rgbValue: 0x1c223a)
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.identifier)
        tableView.register(SummaryCell.self, forCellReuseIdentifier: SummaryCell.identifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        viewModel.countriesViewModel.delegate = self
        viewModel.summaryViewModel.delegate = self
    }
}

extension ListViewController: CountriesViewModelDelegate {
    func fetchCountriesCompleted() {
        stopRefreshControl()
        tableView.reloadData()
    }
}

extension ListViewController: SummaryViewModelDelegate {
    func fetchSummaryCompleted() {
        setTitle()
        tableView.reloadData()
    }
}

extension ListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return viewModel.countriesViewModel.data.countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SummaryCell.identifier, for: indexPath) as! SummaryCell
            cell.summaryData = viewModel.summaryViewModel.summaryData
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.identifier, for: indexPath) as! CountryCell
        let countryName = viewModel.countriesViewModel.data.countries[indexPath.row]
        guard let row = viewModel.countriesViewModel.data.data.first(where: { (name, value) -> Bool in
            return name == countryName
        }) else { fatalError("") }
        
        cell.configure(with: CountryCellViewModel(countryData: row.1, countryName: countryName))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
