//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 31.3.25..
//
import Foundation

struct StatisticsOrder: Codable {
    let nfts: [String]
}

extension StatisticsOrder: Dto {
    func asDictionary() -> [String: String] {
        ["nfts": nfts.joined(separator: ",")]
    }
}

struct StatisticsOrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?
}

final class StatisticsOrderService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchCartNfts(completion: @escaping (Result<StatisticsOrder, Error>) -> Void) {
        let request = StatisticsOrderRequest(httpMethod: .get, dto: nil)
        
        networkClient.send(request: request, type: StatisticsOrder.self, onResponse: { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func updateCartNfts(order: StatisticsOrder, completion: @escaping (Result<Void, Error>) -> Void) {
        let request = StatisticsOrderRequest(httpMethod: .put, dto: order)
        
        networkClient.send(request: request, completionQueue: .main) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                print("StatisticsUserCollectionPresenter: ошибка обновления корзины: \(error)")
                completion(.failure(error))
            }
        }
    }
}
