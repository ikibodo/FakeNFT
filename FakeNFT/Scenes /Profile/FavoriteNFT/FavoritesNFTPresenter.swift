//
//  FavoritesNFTPresenter.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 27.03.2025.
//

import Foundation

protocol FavoritesNFTPresenterProtocol {
    func loadNFTs() -> [Nft]
}

final class FavoritesNFTPresenter: FavoritesNFTPresenterProtocol {

    // MARK: - Private Properties
    private weak var view: FavoritesNFTControllerProtocol?
    private let nftService: NftService
    private var favoriteNFTId: [String]
    private var favoriteNFTs: [Nft] = [
        Nft(id: "28829968-8639-4e08-8853-2f30fcf09783",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Bonnie/3.png")!,
            ],
            name: "Olive Avila",
            rating: 2,
            price: 21.0,
            author: "https://amazing_cerf.fakenfts.org/"),
        Nft(id: "739e293c-1067-43e5-8f1d-4377e744ddde",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png")!,
            ],
            name: "Christi Noel",
            rating: 2,
            price: 36.54,
            author: "https://condescending_almeida.fakenfts.org/"),
        Nft(id: "1e649115-1d4f-4026-ad56-9551a16763ee",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Emma/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Emma/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Brown/Emma/3.png")!,
            ],
            name: "Mattie McDaniel",
            rating: 1,
            price: 28.82,
            author: "https://objective_yalow.fakenfts.org/"),
        Nft(id: "77c9aa30-f07a-4bed-886b-dd41051fade2",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Bethany/3.png")!,
            ],
            name: "Dominique Parks",
            rating: 2,
            price: 49.99,
            author: "https://gracious_noether.fakenfts.org/"),
        Nft(id: "9e472edf-ed51-4901-8cfc-8eb3f617519f",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Oreo/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Oreo/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Oreo/3.png")!,
            ],
            name: "Erwin Barron",
            rating: 2,
            price: 13.61,
            author: "https://wizardly_borg.fakenfts.org/"),
        Nft(id: "594aaf01-5962-4ab7-a6b5-470ea37beb93",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lilo/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lilo/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lilo/3.png")!,
            ],
            name: "Minnie Sanders",
            rating: 2,
            price: 40.59,
            author: "https://wonderful_dubinsky.fakenfts.org/"),
    ]
    
    // MARK: - Init
    init(view: FavoritesNFTControllerProtocol, favoriteNFTId: [String], nftService: NftService) {
        self.view = view
        self.nftService = nftService
        self.favoriteNFTId = favoriteNFTId
    }
    
    // MARK: - Public Methods
    func loadNFTs() -> [Nft] {
        return favoriteNFTs
    }
}
