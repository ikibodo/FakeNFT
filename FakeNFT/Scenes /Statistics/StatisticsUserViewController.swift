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
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .segmentActive
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
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
        buttonContainer.addSubview(button)
        button.frame = buttonContainer.bounds
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func addSubViews() {
        view.addSubview(stackView)
        stackView.addSubview(avatarImageView)
        stackView.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
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
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func didTapButton() {
        navigationController?.popViewController(animated: true)
    }
}
