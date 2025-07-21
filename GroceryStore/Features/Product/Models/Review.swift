import Foundation

struct Review: Codable, Identifiable {
    var id: UUID { UUID() }
    var username: String
    var rating: Int
    var comment: String
    var date: String // yyyy-mm-dd
}
