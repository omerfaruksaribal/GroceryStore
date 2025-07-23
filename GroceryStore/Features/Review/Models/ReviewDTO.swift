import Foundation

struct ReviewDTO: Codable, Hashable, Identifiable {
    var id: UUID { UUID() }
    let username: String
    let rating: Int
    let comment: String
    let date: String
}
