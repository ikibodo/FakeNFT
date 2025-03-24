//
//  MyNFT.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 16.03.2025.
//

import UIKit

enum SortType: Int {
    case rating = 0, price, name
}

final class MyNFTController: UIViewController {
    
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 140
        tableView.register(MyNFTCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        button.addSubview(sortIndicator)

        NSLayoutConstraint.activate([
            sortIndicator.widthAnchor.constraint(equalToConstant: 10),
            sortIndicator.heightAnchor.constraint(equalToConstant: 10),
            sortIndicator.topAnchor.constraint(equalTo: button.topAnchor, constant: 2),
            sortIndicator.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -2)
        ])
        
        return button
    }()
    
    private lazy var sortIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var sortBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(customView: sortButton)
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас ещё нет NFT"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    // MARK: - MOCK
//    private var myNFT = MyNFT(nft: [
//        Nft(id: "ca34d35a-4507-47d9-9312-5ea7053994c0",
//            images: [
//                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/1.png")!,
//                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/2.png")!,
//                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/3.png")!
//            ],
//            name: "Jody Rivers",
//            rating: 3,
//            price: 49.64,
//            author: "https://dazzling_meninsky.fakenfts.org/"),
//        Nft(id: "c14cf3bc-7470-4eec-8a42-5eaa65f4053c",
//            images: [
//                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Nacho/1.png")!,
//                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Nacho/2.png")!,
//                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Nacho/3.png")!
//            ],
//            name: "Daryl Lucas",
//            rating: 2,
//            price: 43.53,
//            author: "https://strange_gates.fakenfts.org/"),
//        Nft(id: "a4edeccd-ad7c-4c7f-b09e-6edec02a812b",
//            images: [
//                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/1.png")!,
//                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/2.png")!,
//                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/3.png")!
//            ],
//            name: "Myrna Cervantes",
//            rating: 5,
//            price: 39.37,
//            author: "https://priceless_leavitt.fakenfts.org/"),
//    ])
    
    private var currentSortType: SortType = .rating
    private let sortTypeKey = "selectedSortType"
    private var myNFTId: [String]
    private var nftService: NftService
    private var myNFT: MyNFT = MyNFT(nft: [])
    
    // MARK: - Initializers
    init(arrayMyNFT: [String], nftService: NftService) {
        self.myNFTId = arrayMyNFT
        self.nftService = nftService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = NSLocalizedString("Profile.MyNFT.title", comment: "Мои NFT")
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = sortBarButtonItem
        
        setupUI()
        let savedSortType = loadSortType()
        sortNfts(by: savedSortType)
        print(myNFTId)
        
        
        
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showSortMenu() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        let sortByPrice = UIAlertAction(title: "По цене" + (currentSortType == .price ? " 🔹" : ""), style: .default) { _ in
            self.sortNfts(by: .price)
        }

        let sortByRating = UIAlertAction(title: "По рейтингу" + (currentSortType == .rating ? " 🔹" : ""), style: .default) { _ in
            self.sortNfts(by: .rating)
        }

        let sortByName = UIAlertAction(title: "По названию" + (currentSortType == .name ? " 🔹" : ""), style: .default) { _ in
            self.sortNfts(by: .name)
        }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)

        alertController.addAction(sortByPrice)
        alertController.addAction(sortByRating)
        alertController.addAction(sortByName)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
    
    private func sortNfts(by type: SortType) {
        switch type {
        case .price:
            myNFT.nft.sort { $0.price < $1.price }
        case .rating:
            myNFT.nft.sort { $0.rating > $1.rating }
        case .name:
            myNFT.nft.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }

        currentSortType = type
        UserDefaults.standard.set(type.rawValue, forKey: sortTypeKey)
        
        updateSortIndicator(isDefault: type == .rating)
        updateEmptyState()
        tableView.reloadData()
    }
    
    private func updateSortIndicator(isDefault: Bool) {
        sortIndicator.isHidden = isDefault
    }
    
    private func updateEmptyState() {
        emptyLabel.isHidden = !myNFT.nft.isEmpty
        tableView.isHidden = myNFT.nft.isEmpty
    }
    
    private func loadSortType() -> SortType {
        let savedValue = UserDefaults.standard.integer(forKey: sortTypeKey)
        return SortType(rawValue: savedValue) ?? .rating
    }
    
    // MARK: - Actions
    @objc private func modalCloseButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func sortButtonTapped() {
        print("Нажата кнопка сортировки")
        showSortMenu()
    }
}

// MARK: - UITableViewDataSource
extension MyNFTController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNFT.nft.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyNFTCell = tableView.dequeueReusableCell()
        cell.configure(nft: myNFT.nft[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDataSource
extension MyNFTController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rating = myNFT.nft[indexPath.row]
        print("Выбрана ячейка с рейтингом \(rating) ⭐️")
    }
}
