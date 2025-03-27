//
//  MyNFTCell.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 21.03.2025.
//

import UIKit
import Kingfisher

final class MyNFTCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Private Properties
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
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
            
            heartButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            heartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            heartButton.widthAnchor.constraint(equalToConstant: 40),
            heartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return view
    }()
    
    private lazy var mainContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 39
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
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var authorDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.heightAnchor.constraint(equalToConstant: 108).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 108).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    private lazy var nftFromAuthorLabel: UILabel = {
        let label = UILabel()
        label.text = "от"
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 1
        label.widthAnchor.constraint(equalToConstant: 16).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftAuthorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nftPriceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var starImageViews: [UIImageView] = []
    
    // MARK: - View Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(nft: Nft) {
        
        nftImageView.kf.setImage(with: nft.images[0], placeholder: UIImage(systemName: "photo"))
        nftNameLabel.text = nft.name
        nftAuthorLabel.text = nft.author
        nftPriceLabel.text = "\(nft.price) ETH"
        
        let clampedRating = max(0, min(nft.rating, 5))
        
        for (index, star) in starImageViews.enumerated() {
            star.image = UIImage(systemName: "star.fill")
            star.tintColor = index < clampedRating ? .systemYellow : .lightGray
        }
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        contentView.addSubview(mainStackView)
        
        [nameAndRatingStackView, priceStackView].forEach { stackView in
            mainContentStackView.addArrangedSubview(stackView)
        }
        
        nameAndRatingStackView.addArrangedSubview(nftNameLabel)
        nameAndRatingStackView.addArrangedSubview(ratingStarsStackView)
        nameAndRatingStackView.addArrangedSubview(authorDetailsStackView)
        
        authorDetailsStackView.addArrangedSubview(nftFromAuthorLabel)
        authorDetailsStackView.addArrangedSubview(nftAuthorLabel)
        
        priceStackView.addArrangedSubview(nftPriceTitleLabel)
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
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39),
            
            ratingStarsStackView.heightAnchor.constraint(equalToConstant: 12),
        ])
    }
    
    // MARK: - Actions
    @objc private func heartButtonTapped() {
        heartButton.tintColor =  (heartButton.tintColor == UIColor.white) ? UIColor.red : UIColor.white
    }
}
