//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 30.3.25..
//
import Foundation

struct StatisticsProfile: Codable {
    let likes: [String]
}

extension StatisticsProfile: Dto {
    func asDictionary() -> [String: String] {
        ["likes": likes.joined(separator: ",")]
    }
}

struct StatisticsProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?
}

final class StatisticsProfileService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchLikesNfts(completion: @escaping (Result<StatisticsProfile, Error>) -> Void) {
        let request = StatisticsProfileRequest(httpMethod: .get, dto: nil)
        
        networkClient.send(request: request, type: StatisticsProfile.self, onResponse: { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func updateLikesNfts(profile: StatisticsProfile, completion: @escaping (Result<Void, Error>) -> Void) {
        let request = StatisticsProfileRequest(httpMethod: .put, dto: profile)
        
        networkClient.send(request: request, completionQueue: .main) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                print("StatisticsProfileService: Ошибка обновления лайков в профиле: \(error)")
                completion(.failure(error))
            }
        }
    }
}
