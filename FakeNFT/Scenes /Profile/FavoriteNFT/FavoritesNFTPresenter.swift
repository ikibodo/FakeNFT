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
    func changeLike(nftId: String, completion: @escaping (Bool) -> Void)
    func setLikeUpdated(_ updated: Bool)
    func isLikeUpdated() -> Bool
}

final class FavoritesNFTPresenter {
    
    // MARK: - Private Properties
    private weak var view: FavoritesNFTControllerProtocol?
    private let nftService: NftService
    private let profileService: ProfileService
    private var favoriteNFTId: [String]
    private var favoriteNFTs: [Nft] = []
    private var userProfile: UserProfile?
    private var likeIsUpdated = false
    
    // MARK: - Init
    init(view: FavoritesNFTControllerProtocol, favoriteNFTId: [String], nftService: NftService, profileService: ProfileService) {
        self.view = view
        self.favoriteNFTId = favoriteNFTId
        self.nftService = nftService
        self.profileService = profileService
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
}

extension FavoritesNFTPresenter: FavoritesNFTPresenterProtocol {
    func loadNFTs() {
        view?.showLoading(true)
        fetchUserProfile { [weak self] in
            guard let self = self else { return }
            
            var failedNftIds: [String] = []
            var loadedNfts: [Nft] = []
            let dispatchGroup = DispatchGroup()
            
            for nftId in self.favoriteNFTId {
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
                self.favoriteNFTs = loadedNfts
                self.favoriteNFTId = loadedNfts.map { $0.id }
                
                if !failedNftIds.isEmpty {
                    self.view?.showError(message: "Некоторые NFT не удалось загрузить.")
                }
                
                self.view?.updateEmptyState(isHidden: !self.favoriteNFTs.isEmpty)
                self.view?.reloadNFTs()
            }
        }
    }
    
    func getNFTsCount() -> Int {
        return favoriteNFTs.count
    }
    
    func getNFT(at index: Int) -> Nft {
        return favoriteNFTs[index]
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
                        self?.favoriteNFTId = updatedProfile.likes
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
    
    func setLikeUpdated(_ updated: Bool) {
        likeIsUpdated = updated
    }

    func isLikeUpdated() -> Bool {
        return likeIsUpdated
    }
}
