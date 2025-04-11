//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 25.3.25..
//
import UIKit

final class StatisticsUserCollectionViewController: UIViewController, StatisticsUserCollectionProtocol, StatisticsUserCollectionCellDelegate {
    private let presenter: StatisticsUserCollectionPresenter?
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .segmentActive
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .segmentActive
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .left
        label.text = NSLocalizedString("Collection.Nft", comment: "Коллекция NFT")
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StatisticsUserCollectionCell.self, forCellWithReuseIdentifier: StatisticsUserCollectionCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(presenter: StatisticsUserCollectionPresenter) {
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
        presenter?.fetchNftDetails()
        presenter?.fetchCartNfts()
        presenter?.fetchLikesNfts()
    }
    
    func showError(_ message: String) {
        print(message)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    func didTapCartButton(nftId: String) {
        presenter?.toggleNftInCart(nftId: nftId)
    }
    
    func didTapLikeButton(nftId: String){
        presenter?.toggleLikesNfts(nftId: nftId)
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        guard (navigationController?.navigationBar) != nil else { return }
        navigationItem.titleView = titleLabel
        let buttonContainer = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        buttonContainer.addSubview(backButton)
        backButton.frame = buttonContainer.bounds
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func addSubViews() {
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension StatisticsUserCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getNftCount() ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticsUserCollectionCell.identifier, for: indexPath) as? StatisticsUserCollectionCell else { return UICollectionViewCell() }
        guard let nft = presenter?.getNft(at: indexPath.row) else { return cell }
        let isInCart = presenter?.isNftInCart(nftId: nft.id) ?? false
        let isLiked = presenter?.isNftLikes(nftId: nft.id) ?? false
        cell.configure(nft: nft, isInCart: isInCart, isLiked: isLiked)
        cell.delegate = self
        return cell
    }
}

extension StatisticsUserCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRowForPad: CGFloat = 4
        let itemsPerRowForPhone: CGFloat = 3
        let itemsPerRow: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? itemsPerRowForPad : itemsPerRowForPhone
        let cellHeight: CGFloat = 192
        let interItemSpacing: CGFloat = 9
        let horizontalPadding: CGFloat = 16
        let sectionInsets = horizontalPadding * 2
        let totalSpacing = (itemsPerRow - 1) * interItemSpacing + sectionInsets
        let availableWidth = max(collectionView.frame.width - totalSpacing, 0)
        let widthPerItem = itemsPerRow > 0 ? availableWidth / itemsPerRow : availableWidth
        return CGSize(width: widthPerItem, height: cellHeight)
    }
}
