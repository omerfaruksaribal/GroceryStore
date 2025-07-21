import Foundation

struct OrderItem: Codable, Identifiable {
    var id: String { productId }           
    let productId: String
    let productName: String
    let quantity: Int
    let price: Double
}

struct OrderResponse: Codable, Identifiable {
    var id: String { orderId }
    let orderId: String
    let address: String
    let date: String        // ISO-8601 YYYY-MM-DD
    let totalAmount: Double
    let items: [OrderItem]
}


struct OrderListResponse: Codable {
    let orders: [OrderResponse]
}
