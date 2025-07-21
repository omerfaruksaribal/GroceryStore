import Foundation

struct CartItem: Codable, Identifiable, Hashable {
    var id: String { productId } // Identifiable
    let productId: String
    let productName: String
    var quantity: Int
    let price: Double

    var lineTotal: Double { Double(quantity) * price }
}
