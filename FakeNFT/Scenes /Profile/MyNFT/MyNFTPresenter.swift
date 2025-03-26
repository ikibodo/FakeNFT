//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 26.03.2025.
//

import Foundation

protocol MyNFTPresenterProtocol {
    func loadNFTs()
    func sortNFTs(by type: SortType)
    func getNFTsCount() -> Int
    func getNFT(at index: Int) -> Nft
    func getCurrentSortType() -> SortType
}

final class MyNFTPresenter: MyNFTPresenterProtocol {
    
    // MARK: - Private Properties
    private weak var view: MyNFTControllerProtocol?
    private let nftService: NftService
    private var myNFTId: [String]
    private var myNFTs: [Nft] = []
    private let sortTypeKey = "selectedSortType"

    // MARK: - Init
    init(view: MyNFTControllerProtocol, myNFTId: [String], nftService: NftService) {
        self.view = view
        self.nftService = nftService
        self.myNFTId = myNFTId
    }
    
    // MARK: - Public Methods
    func loadNFTs() {
        view?.showLoading(true)
        var failedNftIds: [String] = []
        var loadedNfts: [Nft] = []
        let dispatchGroup = DispatchGroup()

        for nftId in myNFTId {
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
            self.myNFTs = loadedNfts
            self.sortNFTs(by: self.loadSortType())

            if !failedNftIds.isEmpty {
                self.view?.showError(message: "Некоторые NFT не удалось загрузить.")
            }

            self.view?.updateEmptyState(isHidden: !self.myNFTs.isEmpty)
            self.view?.reloadNFTs()
        }
    }
    
    func sortNFTs(by type: SortType) {
        switch type {
        case .price:
            myNFTs.sort { $0.price < $1.price }
        case .rating:
            myNFTs.sort { $0.rating > $1.rating }
        case .name:
            myNFTs.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }

        UserDefaults.standard.set(type.rawValue, forKey: sortTypeKey)
        view?.updateSortIndicator(isHidden: type == .rating)
        view?.reloadNFTs()
    }
    
    func getNFTsCount() -> Int {
        return myNFTs.count
    }
    
    func getNFT(at index: Int) -> Nft {
        return myNFTs[index]
    }
    
    func getCurrentSortType() -> SortType {
        return loadSortType()
    }
    
    // MARK: - Private Methods
    private func loadSortType() -> SortType {
        let savedValue = UserDefaults.standard.integer(forKey: sortTypeKey)
        return SortType(rawValue: savedValue) ?? .rating
    }
}
