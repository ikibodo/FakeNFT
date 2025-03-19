import Foundation

struct Nft: Decodable {
    let id: String
    let images: [URL]
    let createdAt, name: String
    let rating: Int
    let description: String
    let price: Double
    let author: String
}
