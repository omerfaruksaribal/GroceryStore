import Foundation

struct Product: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let quantity: Int
    let imageUrl: URL
    let category: String
    let brand: String
    let weight: String
    let reviews: [ReviewDTO]
    let averageRating: Double?

    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
