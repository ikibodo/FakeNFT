//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 17.03.2025.
//

import Foundation

typealias ProfileCompletion = (Result<UserProfile, Error>) -> Void

protocol ProfileService {
    func getProfile() -> UserProfile?
    func loadProfile(completion: @escaping ProfileCompletion)
    func updateProfile(profile: UserProfile, completion: @escaping ProfileCompletion)
}

final class ProfileServiceImp: ProfileService {
    
    // MARK: - Private Properties
    private let networkClient: NetworkClient
    private let storage: ProfileStorage
    
    // MARK: - Initializers
    init(networkClient: NetworkClient, storage: ProfileStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    // MARK: - Public Methods
    func getProfile() -> UserProfile? {
        guard let profile = storage.getProfile() else { return nil }
        return profile
    }
    
    func loadProfile(completion: @escaping ProfileCompletion) {
        let cacheExpirationInterval: TimeInterval = 600
        
        if storage.isProfileCacheValid(expirationInterval: cacheExpirationInterval),
           let profile = storage.getProfile() {
            completion(.success(profile))
            print("Загружено: UserDefaults (актуальные данные)")
            return
        }
        
        let request = ProfileRequest()
        print("""
              method: \(request.httpMethod)
              endpoint: \(request.endpoint!)
              \n
              """)
        networkClient.send(request: request, type: UserProfile.self) { result in
            switch result {
            case .success(let profile):
                self.storage.saveProfile(profile)
                print("Загружено: Backend")
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateProfile(profile: UserProfile,
                       completion: @escaping ProfileCompletion) {
        var request = ProfilePutRequest()
        request.dto = ProfileDtoObject(avatar: profile.avatar,
                                       name: profile.name,
                                       description: profile.description ?? "",
                                       website: profile.website,
                                       likes: profile.likes.joined(separator: ", "))
        print("""
              method: \(request.httpMethod)
              endpoint: \(request.endpoint!)
              dto: \(String(describing: request.dto))
              \n
              """)
        networkClient.send(request: request, type: UserProfile.self) { result in
            switch result {
            case .success(let profile):
                self.storage.saveProfile(profile)
                print("[updateProfile] profile.likes \(profile.likes)")
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
