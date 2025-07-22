import Foundation

struct OrderItem: Codable, Identifiable {
    var id: String { productId }           
    let productId: String
    let productName: String
    let quantity: Int
    let price: Double
}

struct OrderResponse: Codable, Identifiable, Hashable {
    var id: String { orderId }

    let orderId: String
    let address: String
    let date: String
    let totalAmount: Double
    let items: [OrderItem]           

    // Hashable + Equatable (değişmedi)
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.orderId == rhs.orderId }
    func hash(into hasher: inout Hasher) { hasher.combine(orderId) }

    private enum CodingKeys: String, CodingKey {
        case orderId, address, date
        case totalAmount = "total"       // for profile
        case items       = "orderItems"  // for profile
    }
}


struct OrderListResponse: Codable {
    let orders: [OrderResponse]
}
