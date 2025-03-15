//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 15.03.2025.
//

import UIKit

final class ProfileController: UIViewController {
    
    let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mockUserProfile = UserProfile(name: "Студентус Практикумус",
                                              avatar: "mock_avatar",
                                              description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
                                              website: "https://practicum.yandex.ru/ios-developer",
                                              nfts: ["68","69","71","72","73","74","75","76","77","78","79","80","81"],
                                              likes: ["5","13","19","26","27","33","35","39","41","47","56","66"])
    
    private lazy var avatatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.textColor = UIColor.black
        textView.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var websiteTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.dataDetectorTypes = .link
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        avatatarImageView.image = UIImage(named: mockUserProfile.avatar)
        nameLabel.text = mockUserProfile.name
        descriptionTextView.text = mockUserProfile.description
        websiteTextView.text = mockUserProfile.website
        
        view.addSubview(avatatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(websiteTextView)
        
        NSLayoutConstraint.activate([
            avatatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            
            descriptionTextView.topAnchor.constraint(equalTo: avatatarImageView.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            websiteTextView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8),
            websiteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
