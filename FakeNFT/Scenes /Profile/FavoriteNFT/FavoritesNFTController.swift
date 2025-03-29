//
//  FavoritesNFT.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 16.03.2025.
//

import UIKit

protocol FavoritesNFTControllerProtocol: AnyObject {
    func updateEmptyState(isHidden: Bool)
}

final class FavoritesNFTController: UIViewController {
    
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
        layout.itemSize = CGSize(width: (view.frame.width - 8 - 16 * 2) / 2, height: 80)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        
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
    private var favoriteNFTs: [Nft] = []
    
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
        loadNFTs()
        
        updateEmptyState(isHidden: !favoriteNFTs.isEmpty)
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
    
    private func loadNFTs() {
        
        favoriteNFTs = presenter?.loadNFTs() ?? []
        collectionView.reloadData()
    }
    
    func updateEmptyState(isHidden: Bool) {
        emptyLabel.isHidden = isHidden
        collectionView.isHidden = !isHidden
    }
    
    // MARK: - Actions
    @objc private func modalCloseButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FavoritesNFTController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteNFTs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavoriteNFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.configure(with: favoriteNFTs[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesNFTController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNFT = favoriteNFTs[indexPath.item]
        print("Выбрана NFT: \(selectedNFT.name), автор: \(selectedNFT.author), цена: $\(selectedNFT.price)")
    }
}

extension FavoritesNFTController: FavoritesNFTControllerProtocol {
    
}
