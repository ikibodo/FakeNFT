//
//  ProfilePutRequest.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 17.03.2025.
//

import Foundation

struct ProfilePutRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto? // = ProfileDtoObject(param1: "geanj", name: "Студентус")
}

struct ProfileDtoObject: Dto {
    let avatar: String
    let name: String
    let description: String
    let website: String
    let likes: String
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case name
        case description
        case website
        case likes
    }
    
    func asDictionary() -> [String : String] {
        [
            CodingKeys.avatar.rawValue: avatar,
            CodingKeys.name.rawValue: name,
            CodingKeys.description.rawValue: description,
            CodingKeys.website.rawValue: website,
            CodingKeys.likes.rawValue: likes
        ]
    }
}
