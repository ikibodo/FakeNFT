//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 22.3.25..
//
import Foundation

struct UsersRequest: NetworkRequest {
    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)/api/v1/users")
    }
    
    var httpMethod: HttpMethod { .get }
    
    var dto: Dto? { nil }
}

final class StatisticsUserService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchUsers(completion: @escaping (Result<[StatisticsUser], Error>) -> Void) {
        let request = UsersRequest()
        networkClient.send(request: request, type: [StatisticsUser].self, completionQueue: .main, onResponse: completion)
    }
}
