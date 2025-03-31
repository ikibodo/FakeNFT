//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 15.03.2025.
//

import Kingfisher
import UIKit

protocol ProfileControllerProtocol: AnyObject {
    func displayProfileData(_ profile: UserProfile)
    func showError(_ error: Error)
}

final class ProfileController: UIViewController {
    
    // MARK: - Private Properties
    private let servicesAssembly: ServicesAssembly
    private var userProfile: UserProfile?
    private var presenter: ProfilePresenterProtocol?
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
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
    
    private lazy var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var rightBarButton: UIBarButtonItem = {
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let button = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil", withConfiguration: boldConfig),
                                     style: .plain,
                                     target: self,
                                     action: #selector(openEditProfile))
        button.tintColor = UIColor.black
        return button
    }()
    
    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(contentView)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(websiteTextView)
        contentView.addSubview(profileTableView)
        
        setupConstraints()
        UIBlockingProgressHUD.show()
        presenter?.fetchUserProfile()
    }
    
    // MARK: - Public Methods
    func setPresenter(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            websiteTextView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8),
            websiteTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            websiteTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            profileTableView.topAnchor.constraint(equalTo: websiteTextView.bottomAnchor, constant: 40),
            profileTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            profileTableView.heightAnchor.constraint(equalToConstant: 162)
        ])
    }
    
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Повторить попытку", style: .default) { [weak self] _ in
            UIBlockingProgressHUD.show()
            self?.presenter?.fetchUserProfile()
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func openEditProfile() {
        guard let userProfile else { return }
        let editProfileVC = EditProfileController(servicesAssembly: servicesAssembly, userProfile: userProfile)
        let presenter = EditProfilePresenter(view: editProfileVC, profileService: servicesAssembly.profileService)
        editProfileVC.setPresenter(presenter)
        editProfileVC.delegate = self
        present(UINavigationController(rootViewController: editProfileVC), animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension ProfileController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let profile = userProfile else {
            cell.textLabel?.text = "Загрузка..."
            return cell
        }
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Мои NFT (\(profile.nfts.count))"
        case 1:
            cell.textLabel?.text = "Избранные NFT (\(profile.likes.count))"
        case 2:
            cell.textLabel?.text = "О разработчике"
        default:
            break
        }
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        cell.textLabel?.textColor = UIColor.black
        
        let imageView = UIImageView(image: UIImage(systemName: "chevron.forward"))
        imageView.tintColor = UIColor.black
        cell.accessoryView = imageView
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProfileController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let arrayMyNFT = userProfile?.nfts else { return }
            let controller = MyNFTController()
            let presenter = MyNFTPresenter(view: controller, myNFTId: arrayMyNFT, nftService: servicesAssembly.nftService, profileService: servicesAssembly.profileService)
            controller.setPresenter(presenter)
            controller.delegate = self
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            self.navigationController?.present(navigationController, animated: true, completion: nil)
        case 1:
            guard let favoriteNFT = userProfile?.likes else { return }
            let controller = FavoritesNFTController()
            let presenter = FavoritesNFTPresenter(view: controller, favoriteNFTId: favoriteNFT, nftService: servicesAssembly.nftService, profileService: servicesAssembly.profileService)
            controller.setPresenter(presenter)
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        case 2:
            print("Вы выбрали \"О разработчике\"")
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - EditProfileDelegate
extension ProfileController: EditProfileControllerDelegate {
    func didUpdateProfile() {
        presenter?.fetchUserProfile()
    }
}

// MARK: - ProfileView
extension ProfileController: ProfileControllerProtocol {
    func displayProfileData(_ profile: UserProfile) {
        UIBlockingProgressHUD.dismiss()
        userProfile = profile
        
        if let url = URL(string: profile.avatar) {
            print("\n \(url) \n")
            self.avatarImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.circle.fill"))
        }
        
        self.nameLabel.text = profile.name
        self.descriptionTextView.text = profile.description ?? "Описание отсутствует"
        
        let attributedString = NSMutableAttributedString(string: profile.website, attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .regular)
            ])
            attributedString.addAttribute(.link, value: profile.website, range: NSRange(location: 0, length: profile.website.count))
            self.websiteTextView.attributedText = attributedString
        
        self.profileTableView.reloadData()
        self.navigationItem.rightBarButtonItem = self.rightBarButton
        self.contentView.isHidden = false
    }
    
    func showError(_ error: Error) {
        UIBlockingProgressHUD.dismiss()
        showErrorAlert(error: error)
    }
}
