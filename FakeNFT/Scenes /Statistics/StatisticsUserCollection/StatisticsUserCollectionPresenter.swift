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
    private weak var view: StatisticsUserCollectionProtocol?
    private var userId: String?
    private let userNftsId: [String]?
    var userNfts: [StatisticsNft]?
    
    private lazy var nftService: StatisticsUserNFTService = {
        return StatisticsUserNFTService()
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
        return userNfts?[index]
    }
    
    func fetchNftDetails() {
        guard let userNfts = userNftsId, !userNfts.isEmpty else {
            DispatchQueue.main.async {
                self.view?.showError("Нет NFT для загрузки")
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
                    DispatchQueue.main.async {
                        self.view?.showError("Ошибка при загрузке NFT с id \(id): \(error.localizedDescription)")
                    }
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
}
