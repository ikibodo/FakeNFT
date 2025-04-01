//
//  FavoritesNFT.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 16.03.2025.
//

import UIKit
import SafariServices

protocol FavoritesNFTControllerProtocol: AnyObject {
    func reloadNFTs()
    func showError(message: String)
    func showLoading(_ isLoading: Bool)
    func updateEmptyState(isHidden: Bool)
}

struct CollectionViewLayoutConfig {
    static let itemSpacing: CGFloat = 8
    static let lineSpacing: CGFloat = 20
    static let sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
    static let itemsPerRow: CGFloat = 2
}

final class FavoritesNFTController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: EditProfileControllerDelegate?
    
    // MARK: - Private Properties
    private lazy var backButton: UIBarButtonItem = {
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward", withConfiguration: boldConfig),
                                     style: .plain,
                                     target: self,
                                     action: #selector(modalCloseButtonTapped))
        button.tintColor = UIColor.black
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let totalSpacing = CollectionViewLayoutConfig.itemSpacing +
                           CollectionViewLayoutConfig.sectionInset.left +
                           CollectionViewLayoutConfig.sectionInset.right
        layout.itemSize = CGSize(width: (view.frame.width - totalSpacing) / CollectionViewLayoutConfig.itemsPerRow, height: 80)
        layout.minimumInteritemSpacing = CollectionViewLayoutConfig.itemSpacing
        layout.minimumLineSpacing = CollectionViewLayoutConfig.lineSpacing
        layout.sectionInset = CollectionViewLayoutConfig.sectionInset
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(FavoriteNFTCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас ещё нет избранных NFT"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private var presenter: FavoritesNFTPresenterProtocol?
    
    // MARK: - Public Methods
    func setPresenter(_ presenter: FavoritesNFTPresenterProtocol) {
        self.presenter = presenter
    }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = NSLocalizedString("Profile.FavoritesNFT.title", comment: "Избранные NFT")
        navigationItem.leftBarButtonItem = backButton
        
        setupCollectionView()
        presenter?.loadNFTs()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func modalCloseButtonTapped() {
        if presenter?.isLikeUpdated() == true {
            UIBlockingProgressHUD.show()
            delegate?.didUpdateProfile()
            presenter?.setLikeUpdated(false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FavoritesNFTController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getNFTsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavoriteNFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        guard let nft = presenter?.getNFT(at: indexPath.row) else { return cell }
        cell.configure(nft: nft)
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesNFTController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nft = presenter?.getNFT(at: indexPath.row)
        print("Выбрана NFT: \(String(describing: nft?.name)), автор: \(String(describing: nft?.author)), цена: $\(String(describing: nft?.price))")
    }
}

// MARK: - FavoritesNFTControllerProtocol
extension FavoritesNFTController: FavoritesNFTControllerProtocol {
    func reloadNFTs() {
        collectionView.reloadData()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading(_ isLoading: Bool) {
        isLoading ? UIBlockingProgressHUD.show() : UIBlockingProgressHUD.dismiss()
    }
    
    func updateEmptyState(isHidden: Bool) {
        emptyLabel.isHidden = isHidden
        collectionView.isHidden = !isHidden
    }
}

// MARK: - FavoriteNFTCellDelegate
extension FavoritesNFTController: FavoriteNFTCellDelegate {
    func didTaplikeButton(in cell: FavoriteNFTCell, nftId: String) {
        presenter?.changeLike(nftId: nftId) { success in
            DispatchQueue.main.async {
                if success {
                    cell.updateLikeButton()
                } else {
                    self.showError(message: "Ошибка при изменении лайка")
                }
            }
        }
    }
}
