import UIKit

protocol CustomCellViewCartDelegate: AnyObject {
    func cellDidTapDeleteCart(nftId: String, nftImage: URL)
}

final class CustomCellViewCart: UITableViewCell {
    static let reuseIdentifier = "CustomCellView"
    weak var delegate: CustomCellViewCartDelegate?
    private var nftId: String?
    private var nftImage: URL?
    private let mainView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "cartDelete")?.withTintColor(.blackDayText)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    let imageViews: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 12
        image.image = UIImage(named: "mockCart")?.withTintColor(.blackDayText)
        return image
    }()
    private let firstStar: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.heightAnchor.constraint(equalToConstant: 12).isActive = true
        image.image = UIImage(named: "starActive")
        return image
    }()
    private let secondStar: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.heightAnchor.constraint(equalToConstant: 12).isActive = true
        image.image = UIImage(named: "starNoActive")
        return image
    }()
    private let thirdStar: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.heightAnchor.constraint(equalToConstant: 12).isActive = true
        image.image = UIImage(named: "starNoActive")
        return image
    }()
    private let fourthStar: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "starNoActive")
        return image
    }()
    private let fifthStar: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.heightAnchor.constraint(equalToConstant: 12).isActive = true
        image.image = UIImage(named: "starNoActive")
        return image
    }()
    private let nftNameLabel: UILabel = {
        let label = UILabel()
        label.text = "April"
        label.textColor = .blackDayText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    private let nftPriceNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blackDayText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = NSLocalizedString("Cart.price", comment: "Цена")
        return label
    }()
    private let nftPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blackDayText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "1,78 ETH"
        return label
    }()
    private let nameAndRatingStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 4
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        return stack
    }()
    private let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 2
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .leading
        return stack
    }()
    private let priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 2
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
        return stack
    }()
    private let baseStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 12
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        configureConstraits()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    func initCell(nft: Nft) {
        nftNameLabel.text = nft.name
        nftPriceLabel.text = String(nft.price) + " ETH"
        nftId = nft.id
        nftImage = nft.images.first
        setRating(nft.rating)
    }
    
    private func configureView() {
        [mainView].forEach {
            contentView.addSubview($0)
        }
        [firstStar,
         secondStar,
         thirdStar,
         fourthStar,
         fifthStar].forEach {
            ratingStackView.addArrangedSubview($0)
        }
        nameAndRatingStackView.addArrangedSubview(nftNameLabel)
        nameAndRatingStackView.addArrangedSubview(ratingStackView)
        priceStackView.addArrangedSubview(nftPriceNameLabel)
        priceStackView.addArrangedSubview(nftPriceLabel)
        [nameAndRatingStackView,
         priceStackView].forEach {
            baseStackView.addArrangedSubview($0)
        }
        [imageViews,
         baseStackView,
         deleteButton].forEach {
            mainView.addSubview($0)
        }
    }
    
    private func configureConstraits() {
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            imageViews.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            imageViews.topAnchor.constraint(equalTo: mainView.topAnchor),
            imageViews.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            imageViews.widthAnchor.constraint(equalToConstant: 108),
            
            baseStackView.leadingAnchor.constraint(equalTo: imageViews.trailingAnchor, constant: 20),
            baseStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 8),
            baseStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -8),
            
            deleteButton.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 34),
            deleteButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -34),
            deleteButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setRating(_ rating: Int) {
        firstStar.image = UIImage(named: "starNoActive")
        secondStar.image = UIImage(named: "starNoActive")
        thirdStar.image = UIImage(named: "starNoActive")
        fourthStar.image = UIImage(named: "starNoActive")
        fifthStar.image = UIImage(named: "starNoActive")
        switch rating {
        case 1:
            firstStar.image = UIImage(named: "starActive")
        case 2:
            firstStar.image = UIImage(named: "starActive")
            secondStar.image = UIImage(named: "starActive")
        case 3:
            firstStar.image = UIImage(named: "starActive")
            secondStar.image = UIImage(named: "starActive")
            thirdStar.image = UIImage(named: "starActive")
        case 4:
            firstStar.image = UIImage(named: "starActive")
            secondStar.image = UIImage(named: "starActive")
            thirdStar.image = UIImage(named: "starActive")
            fourthStar.image = UIImage(named: "starActive")
        case 5:
            firstStar.image = UIImage(named: "starActive")
            secondStar.image = UIImage(named: "starActive")
            thirdStar.image = UIImage(named: "starActive")
            fourthStar.image = UIImage(named: "starActive")
            fifthStar.image = UIImage(named: "starActive")
        default:
            break
        }
    }
    
    @objc private func deleteButtonTapped() {
        guard let nftId = nftId, let nftImage = nftImage else { return }
        delegate?.cellDidTapDeleteCart(nftId: nftId, nftImage: nftImage)
    }
}
