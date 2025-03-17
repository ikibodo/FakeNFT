//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 15.03.2025.
//

import Kingfisher
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
    
    private var userProfile: UserProfile?
    
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
        loadProfile()
    }
    
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
    
    @objc private func openEditProfile() {
        guard let userProfile else { return }
        let editProfileVC = EditProfileController(servicesAssembly: servicesAssembly, userProfile: userProfile)
        editProfileVC.delegate = self  // Устанавливаем делегат
        present(UINavigationController(rootViewController: editProfileVC), animated: true, completion: nil)
    }
    
    private func loadProfile() {
        servicesAssembly.profileService.loadProfile { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let profile):
                    self.userProfile = profile
                    if let url = URL(string: profile.avatar) {
                        print("\n \(url) \n")
                        self.avatarImageView.kf.setImage(
                            with: url,
                            placeholder: UIImage(systemName: "person.circle.fill"),
                            options: [
                                .transition(.fade(0.3))
                            ],
                            completionHandler: { result in
                                switch result {
                                case .success(let value):
                                    print("Загружено изображение: \(value.source.url?.absoluteString ?? "")")
                                case .failure(let error):
                                    print("Ошибка загрузки: \(error.localizedDescription)")
                                }
                            }
                        )
                    }
                    
                    self.nameLabel.text = profile.name
                    self.descriptionTextView.text = profile.description ?? "Описание отсутствует"
                    self.websiteTextView.text = profile.website
                    
                    self.profileTableView.reloadData()
                    
                    self.navigationItem.rightBarButtonItem = self.rightBarButton
                    self.contentView.isHidden = false // Показываем контент
                case .failure(let error):
                    self.showErrorAlert(error: error)
                }
            }
        }
    }
    
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Повторить попытку", style: .default) { [weak self] _ in
            self?.loadProfile()
        })
        
        present(alert, animated: true)
    }
}

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

extension ProfileController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let controller = MyNFT()
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            self.navigationController?.present(navigationController, animated: true, completion: nil)
        case 1:
            let controller = FavoritesNFT()
            navigationController?.pushViewController(controller, animated: true)
        case 2:
            print("Вы выбрали \"О разработчике\"")
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProfileController: EditProfileDelegate {
    func didUpdateProfile(with updatedProfile: UserProfile) {
        loadProfile()
    }
}
