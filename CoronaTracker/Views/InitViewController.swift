
import Foundation
import NVActivityIndicatorView

class InitViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        view.backgroundColor = .pastelBlue()
        view.addSubview(imageView)
        view.addSubview(indicatorView)
        
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(imageView.snp.width)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalTo(imageView).offset(-6)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.imageView.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview().offset(-20)
        }
        UIView.animate(withDuration: 0.5, delay: 1, options: .curveLinear, animations: {
            self.view.layoutIfNeeded()
        }) {_ in
            self.indicatorView.startAnimating()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            let navigationController = UINavigationController(rootViewController: TabBarController())
            navigationController.navigationBar.barTintColor = UIColor.init(rgbValue: 0x1c223a)
            navigationController.navigationBar.tintColor = UIColor.init(rgbValue: 0x7D9DFF)
            navigationController.navigationBar.isTranslucent = false
            
            guard let window = UIApplication.shared.keyWindow else {return}
            
            window.rootViewController = navigationController
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
                { completed in
            })
            
        }
        
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "app-icon"))
        return imageView
    }()
    
    let indicatorView: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 25, height: 25), type: NVActivityIndicatorType.ballPulseSync, color: .white, padding: 0)
        return view
    }()
}
