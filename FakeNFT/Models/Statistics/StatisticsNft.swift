//
//  Untitled.swift
//  FakeNFT
//
//  Created by N L on 28.3.25..
//
import Foundation

struct StatisticsNft: Decodable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}
