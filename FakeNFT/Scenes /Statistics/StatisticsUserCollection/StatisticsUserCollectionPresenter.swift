//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 25.3.25..
//
import Foundation

protocol StatisticsUserCollectionProtocol: AnyObject {
    func reloadData()
    func showError(_ message: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

final class StatisticsUserCollectionPresenter {
    var userNfts: [StatisticsNft]?
    
    private weak var view: StatisticsUserCollectionProtocol?
    
    private var userId: String?
    private let userNftsId: [String]?
    private var cartNftsId: [String] = []
    private var likesNftsId: [String] = []
    
    private lazy var nftService: StatisticsUserNFTService = {
        return StatisticsUserNFTService()
    }()
    
    private lazy var orderService: StatisticsOrderService = {
        return StatisticsOrderService()
    }()
    
    private lazy var likesService: StatisticsProfileService = {
        return StatisticsProfileService()
    }()
    
    init(userId: String?, userNftsId: [String]?) {
        self.userId = userId
        self.userNftsId = userNftsId
    }
    
    func attachView(_ view: StatisticsUserCollectionViewController) {
        self.view = view
    }
    
    func getNftCount() -> Int {
        return userNftsId?.count ?? 0
    }
    
    func getNft(at index: Int) -> StatisticsNft? {
        guard let userNfts = userNfts, userNfts.indices.contains(index) else { return nil }
        return userNfts[index]
    }
    
    func fetchNftDetails() {
        guard let userNfts = userNftsId, !userNfts.isEmpty else {
            DispatchQueue.main.async {
                self.view?.showError("StatisticsUserCollectionPresenter:  Нет NFT для загрузки")
            }
            return
        }
        
        DispatchQueue.main.async {
            self.view?.showLoadingIndicator()
        }
        
        var nfts: [StatisticsNft] = []
        let dispatchGroup = DispatchGroup()
        
        for id in userNfts {
            dispatchGroup.enter()
            nftService.fetchNftInfo(id: id) { result in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    self.view?.showError("StatisticsUserCollectionPresenter: Ошибка при загрузке NFT с id \(id): \(error)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.userNfts = nfts
            self.view?.reloadData()
            self.view?.hideLoadingIndicator()
        }
    }
    
    func fetchCartNfts() {
        orderService.fetchCartNfts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let order):
                    self?.cartNftsId = order.nfts
                    self?.view?.reloadData()
                case .failure(let error):
                    self?.view?.showError("StatisticsUserCollectionPresenter:  Ошибка загрузки корзины: \(error)")
                }
            }
        }
    }
    
    func toggleNftInCart(nftId: String) {
        if cartNftsId.contains(nftId) {
            cartNftsId.removeAll { $0 == nftId }
        } else {
            cartNftsId.append(nftId)
        }
        
        let updatedOrder = StatisticsOrder(nfts: cartNftsId)
        orderService.updateCartNfts(order: updatedOrder) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.view?.reloadData()
                case .failure(let error):
                    self?.view?.showError("StatisticsUserCollectionPresenter: ошибка обновления корзины: \(error)")
                }
            }
        }
    }
    
    func isNftInCart(nftId: String) -> Bool {
        return cartNftsId.contains(nftId)
    }
    
    func fetchLikesNfts() {
        likesService.fetchLikesNfts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.likesNftsId = profile.likes
                    self?.view?.reloadData()
                case .failure(let error):
                    self?.view?.showError("StatisticsUserCollectionPresenter: ошибка загрузки лайков из профиля: \(error)")
                }
            }
        }
    }
    
    func toggleLikesNfts(nftId: String) {
        if likesNftsId.contains(nftId) {
            likesNftsId.removeAll { $0 == nftId }
        } else {
            likesNftsId.append(nftId)
        }
        
        let updatedProfile = StatisticsProfile(likes: likesNftsId)
        
        likesService.updateLikesNfts(profile: updatedProfile) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.view?.reloadData()
                case .failure(let error):
                    self?.view?.showError("StatisticsUserCollectionPresenter: ошибка обновления лайков в профиле: \(error)")
                }
            }
        }
    }
    
    func isNftLikes(nftId: String) -> Bool {
        return likesNftsId.contains(nftId)
    }
}
