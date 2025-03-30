//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 29.3.25..
//
import Foundation

struct NftRequest: NetworkRequest {
    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
    
    var httpMethod: HttpMethod = .get
    var dto: Dto?
    let id: String
}

final class StatisticsUserNFTService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchNftInfo(id: String, completion: @escaping (Result<StatisticsNft, Error>) -> Void) {
        let request = NftRequest(id: id)
        networkClient.send(request: request, type: StatisticsNft.self, completionQueue: .main, onResponse: completion)
    }
}
