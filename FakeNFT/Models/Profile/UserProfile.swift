//
//  UserProfile.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 15.03.2025.
//

import Foundation

struct UserProfile: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
}
