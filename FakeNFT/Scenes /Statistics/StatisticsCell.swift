//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 21.3.25..
//
import UIKit
import Kingfisher

final class StatisticsCell: UITableViewCell {
    static let identifier = "StatisticsCell"
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .segmentActive
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backgroundLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.backgroundColor = .segmentInactive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userpickImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .yaGrayUniversal
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .segmentActive
        label.text = "Alex"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ownedNFTsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .segmentActive
        label.text = "100"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        addSubViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        contentView.addSubview(ratingLabel)
        contentView.addSubview(backgroundLabel)
        backgroundLabel.addSubview(userpickImageView)
        backgroundLabel.addSubview(nameLabel)
        backgroundLabel.addSubview(ownedNFTsLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            ratingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ratingLabel.widthAnchor.constraint(equalToConstant: 27),
            ratingLabel.heightAnchor.constraint(equalToConstant: 20),
            
            backgroundLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 8),
            backgroundLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundLabel.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            userpickImageView.leadingAnchor.constraint(equalTo: backgroundLabel.leadingAnchor, constant: 16),
            userpickImageView.centerYAnchor.constraint(equalTo: backgroundLabel.centerYAnchor),
            userpickImageView.widthAnchor.constraint(equalToConstant: 28),
            userpickImageView.heightAnchor.constraint(equalToConstant: 28),
            
            nameLabel.leadingAnchor.constraint(equalTo: userpickImageView.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: backgroundLabel.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: ownedNFTsLabel.leadingAnchor, constant: -16),
            
            ownedNFTsLabel.trailingAnchor.constraint(equalTo: backgroundLabel.trailingAnchor, constant: -16),
            ownedNFTsLabel.centerYAnchor.constraint(equalTo: backgroundLabel.centerYAnchor),
            ownedNFTsLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    func configure(_ user: StatisticsUser, index: Int) {
            ratingLabel.text = "\(index)"
            nameLabel.text = user.name
            ownedNFTsLabel.text = "\(user.nfts.count)"
            
        if let url = URL(string: user.avatar ?? "") {
                userpickImageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(systemName: "person.crop.circle.fill"),
                    options: [
                        .transition(.fade(0.2)),
                        .cacheOriginalImage
                    ]
                )
            } else {
                userpickImageView.image = UIImage(systemName: "person.crop.circle.fill")
            }
        }
}
