//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 27.3.25..
//
import UIKit
import Kingfisher

protocol StatisticsUserCollectionCellDelegate: AnyObject {
    func didTapLikeButton(nftId: String)
    func didTapCartButton(nftId: String)
}

final class StatisticsUserCollectionCell: UICollectionViewCell {
    static let identifier = "StatisticsUserCollectionCell"
    weak var delegate: StatisticsUserCollectionCellDelegate?
    
    private var nftId: String?
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.tintColor = .yaGrayUniversal
        imageView.image = UIImage(named: "nftCard")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "likeNoActive"), for: .normal)
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var starsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var starImageView: [UIImageView] = {
        return (0..<5).map { _ in
            let imageView = UIImageView()
            imageView.image = UIImage(named: "starNoActive")
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .segmentActive
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .left
        label.lineBreakMode = .byClipping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .segmentActive
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cardButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cartAdd"), for: .normal)
        button.tintColor = .segmentActive
        button.addTarget(self, action: #selector(didTapCardButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.addSubview(nftImageView)
        nftImageView.addSubview(likeButton)
        self.addSubview(starsStackView)
        self.addSubview(nftNameLabel)
        self.addSubview(nftPriceLabel)
        self.addSubview(cardButton)
        starImageView.forEach { starsStackView.addArrangedSubview($0) }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: self.topAnchor),
            nftImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            starsStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            starsStackView.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor),
            starsStackView.heightAnchor.constraint(equalToConstant: 12),
            
            nftNameLabel.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 5),
            nftNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nftNameLabel.widthAnchor.constraint(equalToConstant: 68),
            nftNameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            nftPriceLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            nftPriceLabel.heightAnchor.constraint(equalToConstant: 12),
            
            cardButton.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 4),
            cardButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cardButton.widthAnchor.constraint(equalToConstant: 40),
            cardButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(nft: StatisticsNft, isInCart: Bool, isLiked: Bool) {
        self.nftId = nft.id
        
        nftNameLabel.text = nft.name
        nftPriceLabel.text = "\(nft.price) ETH"
        
        if let firstImageURL = nft.images.first, let url = URL(string: firstImageURL) {
            nftImageView.kf.setImage(with: url)
        }
        updateStars(rating: nft.rating)
        updateLikeButton(isLiked: isLiked)
        updateCartButton(isInCart: isInCart)
    }
    
    private func updateStars(rating: Int) {
        for (index, imageView) in starImageView.enumerated() {
            if index < rating {
                imageView.image = UIImage(named: "starActive")
            } else {
                imageView.image = UIImage(named: "starNoActive")
            }
        }
    }
    
    private func updateLikeButton(isLiked: Bool){
        let imageName = isLiked ? "likeActive" : "likeNoActive"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    private func updateCartButton(isInCart: Bool)  {
        let imageName = isInCart ? "cartDelete" : "cartAdd"
        cardButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    
    @objc private func didTapLikeButton(){
        guard let nftId = nftId else { return }
        delegate?.didTapLikeButton(nftId: nftId)
    }
    
    @objc private func didTapCardButton(){
        guard let nftId = nftId else { return }
        delegate?.didTapCartButton(nftId: nftId)
    }
}
