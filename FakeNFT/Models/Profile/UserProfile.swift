//
//  UserProfile.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 15.03.2025.
//

import Foundation

struct UserProfile: Codable {
    var name: String
    var avatar: String
    var description: String?
    var website: String
    var nfts: [String]
    var likes: [String]
}

extension UserProfile: Equatable {
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.name == rhs.name &&
               lhs.avatar == rhs.avatar &&
               lhs.description == rhs.description &&
               lhs.website == rhs.website &&
               lhs.nfts == rhs.nfts &&
               lhs.likes == rhs.likes
    }
}
