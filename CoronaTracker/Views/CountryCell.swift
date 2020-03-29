
import Foundation
import UIKit
import SnapKit
import FlagKit

class CountryCell: UITableViewCell {
    
    static let identifier = "CountryCell"
    var viewModel: CountryCellViewModel? {
        didSet {
            guard let viewModel = self.viewModel else {return}
            countryNameLabel.text = viewModel.countryName
            countryNameLabel.text = Locale.current.countryName(from: viewModel.countryName)
            let mutableString = NSMutableAttributedString()
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 0
            mutableString.append(
                NSAttributedString(string: "confirmed".localized(), attributes: [
                    NSAttributedString.Key.paragraphStyle : paragraphStyle,
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                    NSAttributedString.Key.foregroundColor: UIColor.lightText,
                ])
            )
            
            mutableString.append(NSAttributedString(string: "\n"))
            
            mutableString.append(
                NSAttributedString(string: "\(viewModel.countryData.confirmed.toformat())", attributes: [
                    NSAttributedString.Key.paragraphStyle : paragraphStyle,
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
                    NSAttributedString.Key.foregroundColor: UIColor.pastelOrange()
                ])
            )
            
            confirmedValue.attributedText = mutableString
            deathValue.attributedText = getAttributedString(for: "death".localized(), value: viewModel.countryData.death, status: .death)
            curedValue.attributedText = getAttributedString(for: "cured".localized(), value: viewModel.countryData.cured, status: .cured)
            
            countryFlag.image = nil
            countryFlag.snp.updateConstraints { (make) in
                make.width.equalTo(30)
                make.right.equalTo(countryNameLabel.snp.left).offset(-10)
            }
            let locale = Locale(identifier: "en_US_POSIX")
            var countryName = viewModel.countryName
            if countryName == "China" {
                countryName = "China mainland"
            } else if countryName == "Arab Emirates" {
                countryName = "United Arab Emirates"
            } else if countryName == "Korea, South" {
                countryName = "South Korea"
            } else if countryName == "US" {
                countryName = "United States"
            } else if countryName == "Taiwan*" {
                countryName = "Taiwan"
            } else if countryName == "Bosnia and Herzegovina" {
                countryName = "Bosnia & Herzegovina"
            } else if countryName == "Congo (Kinshasa)" {
                countryName = "Congo - Kinshasa"
            } else if countryName == "Trinidad and Tobago" {
                countryName = "Trinidad & Tobago"
            } else if countryName == "Saint Vincent and the Grenadines" {
                countryName = "St. Vincent & Grenadines"
            } else if countryName == "Saint Lucia" {
                countryName = "St. Lucia"
            } else if countryName == "Antigua and Barbuda" {
                countryName = "Antigua & Barbuda"
            } else if countryName == "Holy See" {
                countryName = "Vatican City"
            } else if countryName == "Cote d'Ivoire" {
                countryName = "Côte d’Ivoire"
            }
            
            //countryNameLabel.text = Locale.current.countryName(from: code)
            if let code = locale.isoCode(for: countryName), let flag = Flag(countryCode: code) {
                countryFlag.image = flag.image(style: .roundedRect)
            } else {
                if countryName == "Diamond Princess" {
                    countryFlag.image = UIImage.init(named: "cruise-ship-icon")
                    countryFlag.tintColor = .white
                } else {
                    print("country not found: \(countryName)")
                    countryFlag.snp.updateConstraints { (make) in
                        make.width.equalTo(0)
                        make.right.equalTo(countryNameLabel.snp.left).offset(0)
                    }
                }
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.pastelLightBlue()
        view.layer.cornerRadius = 5
        return view
    }()
    
    var adContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.pastelLightBlue()
        view.layer.cornerRadius = 5
        return view
    }()
    
    var countryNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var countryFlag: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var confirmedValue: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var deathValueIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "death")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate))
        icon.tintColor = .lightText
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    var curedValueIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "cured")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate))
        icon.tintColor = .lightText
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    var deathValue: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var curedValue: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let seperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightText
        return view
    }()
    
    func setupViews() {
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.addSubview(countryFlag)
        containerView.addSubview(countryNameLabel)
        containerView.addSubview(confirmedValue)
        containerView.addSubview(deathValue)
        containerView.addSubview(seperatorLine)
        containerView.addSubview(curedValue)
        containerView.addSubview(deathValueIcon)
        containerView.addSubview(curedValueIcon)
        
        containerView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.right.bottom.equalToSuperview().inset(10)
        }
        
        countryFlag.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(20)
            make.right.equalTo(countryNameLabel.snp.left).offset(-10)
            make.width.equalTo(30)
        }
        
        countryNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countryFlag).inset(-5)
            make.right.equalTo(curedValue.snp.left).priority(.low)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        
        confirmedValue.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(countryNameLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview().inset(10)
        }
        
        deathValueIcon.snp.makeConstraints { (make) in
            make.bottom.equalTo(deathValue.snp.top).inset(-2)
            make.centerX.equalTo(deathValue)
            make.height.equalTo(15)
        }
        
        curedValueIcon.snp.makeConstraints { (make) in
            make.bottom.equalTo(curedValue.snp.top).inset(-2)
            make.centerX.equalTo(curedValue)
            make.height.equalTo(15)
        }
        
        deathValue.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        seperatorLine.snp.makeConstraints { (make) in
            make.right.equalTo(deathValue.snp.left).inset(-10)
            make.width.equalTo(1)
            make.height.equalTo(20)
            make.centerY.equalTo(deathValue).offset(6)
        }
        
        curedValue.snp.makeConstraints { (make) in
            make.right.equalTo(seperatorLine.snp.left).inset(-10)
            make.centerY.equalToSuperview()
        }
        
    }
    
    func configure(with viewModel: CountryCellViewModel) {
        self.viewModel = viewModel
    }
}

extension CountryCell {
    private func getAttributedString(for key: String, value: Int, status: Status) -> NSMutableAttributedString {
        let mutableString = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        
        mutableString.append(
            NSAttributedString(string: "\(key)", attributes: [
                NSAttributedString.Key.paragraphStyle : paragraphStyle,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: UIColor.lightText,
            ])
        )
        
        mutableString.append(NSAttributedString(string: "\n"))
        
        var valueColor = UIColor.white
        
        switch status {
        case .death:
            valueColor = UIColor.pastelRed()
        case .cured:
            valueColor = UIColor.pastelGreen()
        default:
            valueColor = .white
        }
        mutableString.append(
            NSAttributedString(string: "\(value.toformat())", attributes: [
                NSAttributedString.Key.paragraphStyle : paragraphStyle,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor: valueColor
            ])
        )
        
        return mutableString
    }
}
