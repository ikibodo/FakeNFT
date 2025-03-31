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
    func changeLike(nftId: String, completion: @escaping (Bool) -> Void)
    func setLikeUpdated(_ updated: Bool)
    func isLikeUpdated() -> Bool
    func nftIsLiked(nft: Nft) -> Bool
}

final class MyNFTPresenter: MyNFTPresenterProtocol {
    
    // MARK: - Private Properties
    private weak var view: MyNFTControllerProtocol?
    private let nftService: NftService
    private var myNFTId: [String]
    private var myNFTs: [Nft] = []
    private let profileService: ProfileService
    private var userProfile: UserProfile?
    private var likeIsUpdated = false

    // MARK: - Init
    init(view: MyNFTControllerProtocol, myNFTId: [String], nftService: NftService, profileService: ProfileService) {
        self.view = view
        self.nftService = nftService
        self.myNFTId = myNFTId
        self.profileService = profileService
    }
    
    // MARK: - Public Methods
    func loadNFTs() {
        view?.showLoading(true)
        
        fetchUserProfile { [weak self] in
            guard let self = self else { return }
            
            var failedNftIds: [String] = []
            var loadedNfts: [Nft] = []
            let dispatchGroup = DispatchGroup()

            for nftId in self.myNFTId {
                dispatchGroup.enter()
                self.nftService.loadNft(id: nftId) { result in
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

        
        UserPreferences.sortType = type
        view?.updateSortIndicator(isHidden: type == .rating)
        view?.reloadNFTs()
    }
    
    func getNFTsCount() -> Int {
        return myNFTs.count
    }
    
    func getNFT(at index: Int) -> Nft {
        return myNFTs[index]
    }
    
    func nftIsLiked(nft: Nft) -> Bool {
        guard let userProfile else { return false }
        
        if userProfile.likes.contains(nft.id) {
            return true
        } else {
            return false
        }
    }
    
    func getCurrentSortType() -> SortType {
        return loadSortType()
    }
    
    // MARK: - Private Methods
    private func loadSortType() -> SortType {
        let savedValue = UserPreferences.sortType.rawValue
        return SortType(rawValue: savedValue) ?? .rating
    }
    
    func changeLike(nftId: String, completion: @escaping (Bool) -> Void) {
        fetchUserProfile { [weak self] in
            guard let self = self, var userProfile = self.userProfile else {
                completion(false)
                return
            }
            
            if userProfile.likes.contains(nftId) {
                if userProfile.likes.count == 1 {
                    userProfile.likes = ["null"]
                } else {
                    userProfile.likes.removeAll { $0 == nftId }
                }
            } else {
                userProfile.likes.append(nftId)
            }
            
            profileService.updateProfile(profile: userProfile) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let updatedProfile):
                        self?.userProfile = updatedProfile
                        self?.myNFTId = updatedProfile.nfts
                        self?.likeIsUpdated = true
                        self?.loadNFTs()
                        completion(true)
                    case .failure:
                        self?.view?.showError(message: "Не удалось обновить лайк")
                        completion(false)
                    }
                }
            }
        }
    }
    
    func fetchUserProfile(completion: @escaping () -> Void) {
        profileService.loadProfile { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let profile):
                    self.userProfile = profile
                case .failure:
                    self.view?.showError(message: "Не удалось загрузить данные пользователя")
                }
                completion()
            }
        }
    }
    
    func setLikeUpdated(_ updated: Bool) {
        likeIsUpdated = updated
    }

    func isLikeUpdated() -> Bool {
        return likeIsUpdated
    }
}
