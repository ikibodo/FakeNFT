//
//  ProfilePutService.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 17.03.2025.
//

import Foundation

typealias ProfilePutCompletion = (Result<UserProfile, Error>) -> Void

protocol ProfilePutService {
    func sendProfilePutRequest(
        avatar: String,
        name: String,
        description: String,
        website: String,
        likes: String,
        completion: @escaping ProfilePutCompletion
    )
}

final class ProfilePutServiceImpl: ProfilePutService {
    
    // MARK: - Private Properties
    private let networkClient: NetworkClient
    
    // MARK: - Initializers
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - Public Methods
    func sendProfilePutRequest(
        avatar: String,
        name: String,
        description: String,
        website: String,
        likes: String,
        completion: @escaping ProfilePutCompletion
    ) {
        let dto = ProfileDtoObject(avatar: avatar, name: name, description: description, website: website, likes: likes)
        let request = ProfilePutRequest(dto: dto)
        networkClient.send(request: request, type: UserProfile.self) { result in
            switch result {
            case .success(let putResponse):
                completion(.success(putResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
