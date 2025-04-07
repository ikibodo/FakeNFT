import Foundation

struct Nft: Codable {
    let id: String
    let createdAt, name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
}
