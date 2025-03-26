//
//  CartGetNftsRequest.swift
//  FakeNFT
//
//  Created by Diliara Sadrieva on 26.03.2025.
//

import Foundation

struct CartGetNftsRequest: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Dto?
    init(nftId: String) {
        guard let endpoint = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/nft/\(nftId)") else {
            self.endpoint = nil
            self.httpMethod = .get
            self.dto = nil
            return
        }
        self.endpoint = endpoint
        self.httpMethod = .get
        self.dto = nil
    }
}
