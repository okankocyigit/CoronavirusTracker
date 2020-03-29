
import Foundation
import OpenGraph
import Haneke

class NewsViewCell: UITableViewCell {
    static let identifier = "NewsViewCell"
    var data: NewsFeedModel? {
        didSet {
            titleLabel.text = data?.title
            sourceLabel.text = data?.source
            pubDateLabel.text = data?.pubDate
            newsImage.image = UIColor.pastelBlue().toImage()
            
            if let source = data?.link {
                let cache = Shared.stringCache
                cache.fetch(key: source, failure: { [weak self] (error) in
                    if let url = URL.init(string: source) {
                        OpenGraph.fetch(url: url) { [weak self] result in
                            switch result {
                            case .success(let og):
                                if let image = og[.image] {
                                    let cache = Shared.stringCache
                                    guard let ogimageUrl = URL.init(string: image) else {break}
                                    cache.set(value: image, key: source)
                                    DispatchQueue.main.async {
                                        self?.newsImage.hnk_setImageFromURL(ogimageUrl)
                                    }
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }) { [weak self] (sourceFromCache) in
                    DispatchQueue.main.async {
                        guard let ogimageUrl = URL.init(string: sourceFromCache) else {return}
                        self?.newsImage.hnk_setImageFromURL(ogimageUrl)
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
    
    var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.font = .preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        return lbl
    }()
    
    var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIColor.pastelBlue().toImage()
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var sourceLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.pastelOrange()
        lbl.numberOfLines = 0
        lbl.font = .preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        return lbl
    }()
    
    var pubDateLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.lightText
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 10)
        return lbl
    }()
    
    
    func setupViews() {
        backgroundColor = .clear
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(newsImage)
        containerView.addSubview(sourceLabel)
        containerView.addSubview(pubDateLabel)
        
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.right.equalTo(newsImage.snp.left).inset(-10)
            make.bottom.equalTo(sourceLabel.snp.top).inset(-20)
        }
        
        newsImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(80)
            make.height.equalTo(newsImage.snp.width)
        }
        
        sourceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(pubDateLabel.snp.top).inset(-5)
        }
        
        pubDateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
}
