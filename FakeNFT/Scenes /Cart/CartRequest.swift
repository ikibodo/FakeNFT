//
//  CartRequest.swift
//  FakeNFT
//
//  Created by Diliara Sadrieva on 25.03.2025.
//

import Foundation

struct CartRequest: NetworkRequest {
    var endpoint: URL?
    var httpMethod: HttpMethod
    var dto: Dto?
    init() {
        guard let endpoint = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/1") else {
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
