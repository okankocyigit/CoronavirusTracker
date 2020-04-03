
import Foundation
import UIKit
import MapKit
import SnapKit
import BTNavigationDropdownMenu

class MapViewController: UIViewController {
    var countriesViewModel: CountriesViewModel
    var summaryViewModel: SummaryViewModel
    let items = ["confirmed".localized(), "death".localized(), "cured".localized()]
    
    lazy var menuView: BTNavigationDropdownMenu = {
        let view = BTNavigationDropdownMenu(title: BTTitle.index(0), items: items)
        view.cellTextLabelColor = .white
        view.cellSelectionColor = .pastelLightBlue()
        view.backgroundColor = .white
        view.menuTitleColor = .black
        view.cellTextLabelFont = .systemFont(ofSize: 16)
        view.selectedCellTextLabelColor = .white
        view.alpha = 0.3
        return view
    }()
    
    lazy var rightBarButton: UIBarButtonItem = {
        let item = UIBarButtonItem.init(image: UIImage.init(named: "filter-icon"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.plain, target: self, action: #selector(mapTypeButtonTap))
        
        item.tintColor = .lightText
        return item
    }()
    
    init(apiService: ApiService) {
        countriesViewModel = CountriesViewModel(apiService: apiService, groupByCountry: false)
        summaryViewModel = SummaryViewModel(apiService: apiService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        countriesViewModel.delegate = self
        summaryViewModel.delegate = self
        mapView.delegate = self
        countriesViewModel.fetchCountries()
        summaryViewModel.fetchSummary()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTitle()
        self.tabBarController?.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    @objc func mapTypeButtonTap() {
        menuView.toggle()
    }
    
    private func setTitle() {
        var subTitle = ""
        if let timeStamp = Double(summaryViewModel.summaryData.updatedAt) {
            let time = DateHelper.getLocalRelativeDateString(from: timeStamp)
            subTitle = "\("Last update".localized()): \(time)"
        }
        
        self.tabBarController?.navigationItem.setTitle("Corona Tracker".localized(), subtitle: subTitle)
    }
    
    func setupViews() {
        view.addSubview(mapView)
        view.addSubview(menuView)
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            
            if indexPath == 0 {
                self?.renderAnnotations(with: Status.confirmed)
            } else if indexPath == 1 {
                self?.renderAnnotations(with: Status.death)
            } else if indexPath == 2 {
                self?.renderAnnotations(with: Status.cured)
            }
        }
        
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let region = MKCoordinateRegion(.world)
        mapView.setRegion(region, animated: true)
    }
    
    lazy var mapView: MKMapView = {
        let mV = MKMapView()
        mV.delegate = self
        return mV
    }()
}

extension MapViewController: CountriesViewModelDelegate {
    
    func renderAnnotations(with status: Status) {
        for annotation in mapView.annotations{
            mapView.removeAnnotation(annotation)
        }
        
        for (name, data) in countriesViewModel.data.data {
            switch status {
            case .confirmed:
                if data.confirmed == 0 {
                    continue
                }
            case .cured:
                if data.cured == 0 {
                    continue
                }
            case .suspected:
                if data.suspected == 0 {
                    continue
                }
            case .death:
                if data.death == 0 {
                    continue
                }
            }
            if let lat = data.lat, let lng = data.lng {
                self.mapView.addAnnotation(CircleAnnotation.init(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng), name: name, data: data, status: status))
            }
        }
        
    }
    
    func fetchCountriesCompleted() {
        mapView.removeOverlays(mapView.overlays)
        renderAnnotations(with: Status.confirmed)
    }
}

extension MapViewController: SummaryViewModelDelegate {
    func fetchSummaryCompleted() {
        setTitle()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        guard let annotation = annotation as? CircleAnnotation else {
            return nil
        }
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CircleAnnotationView.identifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = CircleAnnotationView(annotation: annotation, reuseIdentifier: CircleAnnotationView.identifier)
        }
        
        return annotationView
    }
}
