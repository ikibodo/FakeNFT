//
//  ProfileByldRequest.swift
//  FakeNFT
//
//  Created by Aleksandr Dugaev on 17.03.2025.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var dto: Dto?
}
