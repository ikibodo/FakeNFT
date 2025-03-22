//
//  MyNFT.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 16.03.2025.
//

import UIKit

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
    
    // MARK: - MOCK
    private let mockNFTs = MyNFT(nft: [
        Nft(id: "ca34d35a-4507-47d9-9312-5ea7053994c0",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/3.png")!
            ],
            name: "Jody Rivers",
            rating: 3,
            price: 49.64,
            author: "https://dazzling_meninsky.fakenfts.org/"),
        Nft(id: "c14cf3bc-7470-4eec-8a42-5eaa65f4053c",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Nacho/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Nacho/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Nacho/3.png")!
            ],
            name: "Daryl Lucas",
            rating: 2,
            price: 43.53,
            author: "https://strange_gates.fakenfts.org/"),
        Nft(id: "a4edeccd-ad7c-4c7f-b09e-6edec02a812b",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/3.png")!
            ],
            name: "Myrna Cervantes",
            rating: 5,
            price: 39.37,
            author: "https://priceless_leavitt.fakenfts.org/"),
    ])
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = NSLocalizedString("Profile.MyNFT.title", comment: "Мои NFT")
        navigationItem.leftBarButtonItem = backButton
        
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    // MARK: - Actions
    @objc private func modalCloseButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MyNFTController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockNFTs.nft.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyNFTCell = tableView.dequeueReusableCell()
        cell.configure(nft: mockNFTs.nft[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDataSource
extension MyNFTController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rating = mockNFTs.nft[indexPath.row]
        print("Выбрана ячейка с рейтингом \(rating) ⭐️")
    }
}
