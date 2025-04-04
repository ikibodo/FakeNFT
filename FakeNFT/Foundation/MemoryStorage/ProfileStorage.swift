//
//  ProfileStorage.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 17.03.2025.
//

import Foundation

protocol ProfileStorage: AnyObject {
    func saveProfile(_ profile: UserProfile)
    func getProfile() -> UserProfile?
    func isProfileCacheValid(expirationInterval: TimeInterval) -> Bool
}

final class ProfileStorageImpl: ProfileStorage {
    
    private let profileKey = "userProfileKey"
    private let lastUpdateKey = "lastProfileUpdateDate"
    private let userDefaults = UserDefaults.standard
    
    func saveProfile(_ profile: UserProfile) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(profile)
            userDefaults.set(data, forKey: profileKey)
            userDefaults.set(Date(), forKey: lastUpdateKey)
        } catch {
            print("Ошибка при сохранении профиля: \(error.localizedDescription)")
        }
    }
    
    func getProfile() -> UserProfile? {
        if let data = userDefaults.data(forKey: profileKey) {
            let decoder = JSONDecoder()
            do {
                let profile = try decoder.decode(UserProfile.self, from: data)
                return profile
            } catch {
                print("Ошибка при получении профиля: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func isProfileCacheValid(expirationInterval: TimeInterval) -> Bool {
        guard let lastUpdate = userDefaults.object(forKey: lastUpdateKey) as? Date else {
            return false
        }
        return Date().timeIntervalSince(lastUpdate) < expirationInterval
    }
}

