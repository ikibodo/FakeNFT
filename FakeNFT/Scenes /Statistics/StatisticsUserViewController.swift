//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 22.3.25..
//
import UIKit
import Kingfisher

final class StatisticsUserViewController: UIViewController, StatisticsUserViewProtocol {
    private let presenter: StatisticsUserPresenter?
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .segmentActive
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .yaGrayUniversal
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .segmentActive
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .segmentActive
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userWebsiteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setTitle(NSLocalizedString("User.site", comment: ""), for: .normal)
        button.setTitleColor(.segmentActive, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.segmentActive.cgColor
        button.addTarget(self, action: #selector(didTapUserWebsiteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(presenter: StatisticsUserPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter?.attachView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        addSubViews()
        addConstraints()
        presenter?.loadUserData()
    }
    
    func updateUserInfo(_ user: StatisticsUser) {
        nameLabel.text = user.name
        descriptionLabel.text = user.description
        if let url = URL(string: user.avatar ?? "") {
            avatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.crop.circle.fill"),
                options: [ .cacheOriginalImage ]
            )
        } else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        guard (navigationController?.navigationBar) != nil else { return }
        
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        buttonContainer.addSubview(backButton)
        backButton.frame = buttonContainer.bounds
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func addSubViews() {
        view.addSubview(stackView)
        stackView.addSubview(avatarImageView)
        stackView.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(userWebsiteButton)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalToConstant: 70),
            
            avatarImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            avatarImageView.topAnchor.constraint(equalTo: stackView.topAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            userWebsiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            userWebsiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userWebsiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userWebsiteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapUserWebsiteButton() {
        guard let website = presenter?.getUserWebsite(), !website.isEmpty else {
            print("Некорректный URL")
            return
        }
        let webPresenter = StatisticsWebViewPresenter(websiteURL: website)
        let webVC = StatisticsWebViewController(presenter: webPresenter)
        navigationController?.pushViewController(webVC, animated: true)
    }
}
