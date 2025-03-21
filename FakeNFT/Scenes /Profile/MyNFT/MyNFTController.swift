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
    }
    
    // MARK: - Actions
    @objc private func modalCloseButtonTapped() {
        dismiss(animated: true)
    }
}
