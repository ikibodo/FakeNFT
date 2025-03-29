//
//  FavoritesNFTPresenter.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 27.03.2025.
//

import Foundation

protocol FavoritesNFTPresenterProtocol {
    func loadNFTs()
    func getNFTsCount() -> Int
    func getNFT(at index: Int) -> Nft
}

final class FavoritesNFTPresenter {

    // MARK: - Private Properties
    private weak var view: FavoritesNFTControllerProtocol?
    private let nftService: NftService
    private var favoriteNFTId: [String]
    private var favoriteNFTs: [Nft] = []
    
    // MARK: - Init
    init(view: FavoritesNFTControllerProtocol, favoriteNFTId: [String], nftService: NftService) {
        self.view = view
        self.nftService = nftService
        self.favoriteNFTId = favoriteNFTId
    }
}

extension FavoritesNFTPresenter: FavoritesNFTPresenterProtocol {
    func loadNFTs() {
        view?.showLoading(true)
        var failedNftIds: [String] = []
        var loadedNfts: [Nft] = []
        let dispatchGroup = DispatchGroup()

        for nftId in favoriteNFTId {
            dispatchGroup.enter()
            nftService.loadNft(id: nftId) { result in
                switch result {
                case .success(let nft):
                    loadedNfts.append(nft)
                case .failure:
                    failedNftIds.append(nftId)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.view?.showLoading(false)
            self.favoriteNFTs = loadedNfts

            if !failedNftIds.isEmpty {
                self.view?.showError(message: "Некоторые NFT не удалось загрузить.")
            }

            self.view?.updateEmptyState(isHidden: !self.favoriteNFTs.isEmpty)
            self.view?.reloadNFTs()
        }
    }
    
    func getNFTsCount() -> Int {
        return favoriteNFTs.count
    }
    
    func getNFT(at index: Int) -> Nft {
        return favoriteNFTs[index]
    }
}
