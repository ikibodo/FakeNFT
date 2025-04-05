//
//  StatisticsUser.swift
//  FakeNFT
//
//  Created by N L on 21.3.25..
//
import Foundation

struct StatisticsUser: Decodable {
    let name: String
    let avatar: String?
    let description: String?
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
