//
//  FavoriteNFTCell.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 27.03.2025.
//

import UIKit
import Kingfisher

protocol FavoriteNFTCellDelegate: AnyObject {
    func didTaplikeButton(in cell: FavoriteNFTCell, nftId: String)
}

final class FavoriteNFTCell: UICollectionViewCell, ReuseIdentifying {
    // MARK: - Public Properties
    weak var delegate: FavoriteNFTCellDelegate?
    
    // MARK: - Private Properties
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.addArrangedSubview(nftContainerView)
        stackView.addArrangedSubview(mainContentStackView)
        return stackView
    }()
    
    private lazy var nftContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nftImageView)
        view.addSubview(heartButton)
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: view.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            heartButton.topAnchor.constraint(equalTo: view.topAnchor, constant: -6.19),
            heartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 6.19),
            heartButton.widthAnchor.constraint(equalToConstant: 42),
            heartButton.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        return view
    }()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(likeButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var mainContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var nameAndRatingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingStarsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    private var starImageViews: [UIImageView] = []
    private var nftId = ""

    // MARK: - View Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(nft: Nft) {
        nftNameLabel.text = nft.name
        nftPriceLabel.text = "\(nft.price) ETH"
        nftImageView.kf.setImage(with: nft.images[0], placeholder: UIImage(systemName: "photo"))
        heartButton.tintColor = UIColor.red
        nftId = nft.id
        
        let clampedRating = max(0, min(nft.rating, 5))
        
        for (index, star) in starImageViews.enumerated() {
            star.image = UIImage(systemName: "star.fill")
            star.tintColor = index < clampedRating ? .systemYellow : .lightGray
        }
    }
    
    func updateLikeButton() {
        heartButton.tintColor = heartButton.tintColor == UIColor.white ? UIColor.red : UIColor.white
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        contentView.addSubview(mainStackView)
        
        mainContentStackView.addArrangedSubview(nameAndRatingStackView)
        mainContentStackView.addArrangedSubview(priceStackView)
        
        nameAndRatingStackView.addArrangedSubview(nftNameLabel)
        nameAndRatingStackView.addArrangedSubview(ratingStarsStackView)
        
        priceStackView.addArrangedSubview(nftPriceLabel)
        
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            ratingStarsStackView.addArrangedSubview(starImageView)
            starImageViews.append(starImageView)
            
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                starImageView.heightAnchor.constraint(equalToConstant: 12),
                starImageView.widthAnchor.constraint(equalToConstant: 12)
            ])
        }
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            ratingStarsStackView.heightAnchor.constraint(equalToConstant: 12),
        ])
    }
    
    // MARK: - Actions
    @objc private func likeButton() {
        delegate?.didTaplikeButton(in: self, nftId: nftId)
    }
}

