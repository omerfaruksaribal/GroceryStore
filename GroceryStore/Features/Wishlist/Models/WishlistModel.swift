import Foundation

struct WishlistItem: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let imageUrl: URL
}

struct WishlistResponse: Codable {
    let wishlist: [WishlistItem]
}
