//
//  EditProfile.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 16.03.2025.
//

import Kingfisher
import UIKit

protocol EditProfileControllerDelegate: AnyObject {
    func didUpdateProfile(with updatedProfile: UserProfile)
}

protocol EditProfileControllerProtocol: AnyObject {
    func displayUpdatedProfileData(_ updatedProfile: UserProfile)
    func showError(_ error: Error)
}

final class EditProfileController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: EditProfileControllerDelegate?
    
    // MARK: - Private Properties
    private let servicesAssembly: ServicesAssembly
    private var userProfile: UserProfile
    private var presenter: EditProfilePresenterProtocol?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var closeButton: UIBarButtonItem = {
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark", withConfiguration: boldConfig),
                                     style: .plain,
                                     target: self,
                                     action: #selector(modalCloseButtonTapped))
        button.tintColor = UIColor.black
        return button
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var overlayView: UIView = {
        let overlay = UIView()
        overlay.layer.cornerRadius = 35
        overlay.clipsToBounds = true
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        overlay.addGestureRecognizer(tapGesture)
        return overlay
    }()
    
    private lazy var changePhotoLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Profile.EditProfile.changeFoto", comment: "Сменить фото")
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Profile.EditProfile.name", comment: "Имя")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.tag = 1
        textField.backgroundColor = UIColor.lightGray
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = UIColor.black
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Profile.EditProfile.description", comment: "Описание")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.backgroundColor = UIColor.lightGray
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.textColor = UIColor.black
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Profile.EditProfile.website", comment: "Сайт")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var websiteTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.tag = 2
        textField.backgroundColor = UIColor.lightGray
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor.black
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly, userProfile: UserProfile) {
        self.servicesAssembly = servicesAssembly
        self.userProfile = userProfile
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = closeButton
        
        presenter = EditProfilePresenter(view: self, servicesAssembly: servicesAssembly)
        
        if let url = URL(string: userProfile.avatar) {
            print("\n \(url) \n")
            avatarImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.circle.fill"))
        }
        nameTextField.text = userProfile.name
        descriptionTextView.text = userProfile.description
        websiteTextField.text = userProfile.website
        
        setupKeyboardObservers()
        setupTapGesture()
        setupUI()
        setupLayout()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(overlayView)
        contentView.addSubview(changePhotoLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(websiteLabel)
        contentView.addSubview(websiteTextField)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            
            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            overlayView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            overlayView.heightAnchor.constraint(equalToConstant: 70),
            overlayView.widthAnchor.constraint(equalToConstant: 70),
            
            changePhotoLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            changePhotoLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            changePhotoLabel.heightAnchor.constraint(equalToConstant: 24),
            changePhotoLabel.widthAnchor.constraint(equalToConstant: 45),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 132),
            
            websiteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            websiteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            websiteTextField.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 8),
            websiteTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            websiteTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            websiteTextField.heightAnchor.constraint(equalToConstant: 44),
            
            websiteTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func showSnackbar(message: String, isSuccess: Bool) {
        let snackbarHeight: CGFloat = 50
        
        let snackbar = UIView()
        snackbar.backgroundColor = isSuccess ? UIColor.green : UIColor.red
        snackbar.alpha = 0.0
        snackbar.layer.cornerRadius = 25
        snackbar.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        snackbar.addSubview(label)
        view.addSubview(snackbar)
        
        snackbar.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            snackbar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            snackbar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            snackbar.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            snackbar.heightAnchor.constraint(equalToConstant: snackbarHeight),
            
            label.centerXAnchor.constraint(equalTo: snackbar.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: snackbar.centerYAnchor)
        ])
        
        UIView.animate(withDuration: 0.3, animations: {
            snackbar.alpha = 1.0
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                UIView.animate(withDuration: 0.3, animations: {
                    snackbar.alpha = 0.0
                }) { _ in
                    snackbar.removeFromSuperview()
                }
            }
        }
    }
    
    // MARK: - Actions
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = keyboardFrame.height + 20
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func modalCloseButtonTapped() {
        let currentProfile = servicesAssembly.profileService.getProfile()
        
        if userProfile != currentProfile {
            navigationItem.rightBarButtonItem = nil
            presenter?.updateProfile(profile: userProfile)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func avatarTapped() {
        if avatarImageView.image == UIImage(named: "mock_avatar") {
            userProfile.avatar = "https://img.championat.com/s/1350x900/news/big/k/k/obzor-filma-betmen-2022_16469273721670946255.jpg"
            avatarImageView.image = UIImage(named: "mock_avatar_batman")
            print("[Аватарка] изображение изменено на mock_avatar_batman")
        } else {
            userProfile.avatar = "https://www.innov.ru/upload/iblock/ad4/ad41054842078faec12bdda7eb2a98a4.jpg"
            avatarImageView.image = UIImage(named: "mock_avatar")
            print("[Аватарка] изображение изменено на mock_avatar")
        }
    }
}

// MARK: - UITextFieldDelegate
extension EditProfileController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Используем tag для различения полей
        switch textField.tag {
        case 1:
            userProfile.name = textField.text ?? ""
            print("[Имя] Сохранено значение: \(textField.text ?? "")")
        case 2:
            userProfile.website = textField.text ?? ""
            print("[Сайт] Сохранено значение: \(textField.text ?? "")")
        default:
            break
        }
    }
}

// MARK: - UITextViewDelegate
extension EditProfileController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        // Сохраняем введенное значение
        if let enteredText = textView.text {
            userProfile.description = enteredText
            print("[Описание] Сохраненное значение: \(enteredText)")
        }
    }
}

// MARK: - EditProfileView
extension EditProfileController: EditProfileControllerProtocol {
    func displayUpdatedProfileData(_ updatedProfile: UserProfile) {
        print("""
                "name": "\(updatedProfile.name)"
                "avatar": "\(updatedProfile.avatar)"
                "description": "\(updatedProfile.description ?? "null")"
                "website": "\(updatedProfile.website)"
                "nfts": "\(updatedProfile.nfts)"
                "likes": "\(updatedProfile.likes)"
              """)
        self.showSnackbar(message: "Профиль обновлен!", isSuccess: true)
        self.delegate?.didUpdateProfile(with: updatedProfile)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.dismiss(animated: true)
        }
    }
    
    func showError(_ error: any Error) {
        print(error)
        self.showSnackbar(message: "Ошибка обновления профиля!", isSuccess: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.navigationItem.rightBarButtonItem = self.closeButton
        }
    }
}



