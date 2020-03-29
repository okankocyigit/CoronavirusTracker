
import Foundation
import MapKit

class CircleAnnotationView: MKAnnotationView {
    
    static let identifier = "CircleAnnotationView"
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.backgroundColor = .clear
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.baselineAdjustment = .alignCenters
        self.addSubview(label)
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    override var annotation: MKAnnotation? {
        didSet {
            configure()
        }
    }
    
    func configure() {
        guard let annotation = annotation as? CircleAnnotation else { return }
        let count = annotation.data?.confirmed ?? 0
        canShowCallout = false
        countLabel.text = "\(count)"
        countLabel.numberOfLines = 2
        let diameter = radius(for: count) * 2
        self.frame.size = CGSize(width: diameter, height: diameter)
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        self.layer.backgroundColor = UIColor.pastelRed().cgColor
        if annotation.status == Status.death {
            self.layer.backgroundColor = UIColor.pastelRed().cgColor
            if let count = annotation.data?.death {
                countLabel.text = "\(count)"
            }
        } else if annotation.status == Status.confirmed {
            self.layer.backgroundColor = UIColor.pastelOrange().cgColor
            if let count = annotation.data?.confirmed {
                countLabel.text = "\(count)"
            }
        } else if annotation.status == Status.cured {
            self.layer.backgroundColor = UIColor.pastelGreen().cgColor
            if let count = annotation.data?.cured {
                countLabel.text = "\(count)"
            }
        } else if annotation.status == Status.suspected {
            self.layer.backgroundColor = UIColor.yellow.cgColor
            if let count = annotation.data?.suspected {
                countLabel.text = "\(count)"
            }
        }
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.5
    }
    
    func radius(for count: Int) -> CGFloat {
        if count < 5 {
            return 12
        } else if count < 10 {
            return 16
        } else if count < 15 {
            return 20
        } else if count < 100 {
            return 20
        } else if count < 1000 {
            return 22
        } else if count < 100000 {
            return 25
        } else {
            return 30
        }
    }
}
