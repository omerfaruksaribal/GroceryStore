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
    let date: String          // “YYYY-MM-DD”
    let total: Double
    let items: [OrderItem]

    enum CodingKeys: String, CodingKey {
        case orderId, address, date, total, totalAmount, items, orderItems
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        orderId = try c.decode(String.self, forKey: .orderId)
        address = try c.decode(String.self, forKey: .address)
        date    = try c.decode(String.self, forKey: .date)

        // total  • önce total, yoksa totalAmount
        // total • prefer "total", fall back to "totalAmount"
        if let t = try? c.decode(Double.self, forKey: .total) {
            total = t
        } else {
            total = try c.decode(Double.self, forKey: .totalAmount)
        }

        // items • önce items, yoksa orderItems
        // items • prefer "items", fall back to "orderItems"
        if let its = try? c.decode([OrderItem].self, forKey: .items) {
            items = its
        } else {
            items = try c.decode([OrderItem].self, forKey: .orderItems)
        }
    }

    // Encodable side – encode using primary keys
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(orderId, forKey: .orderId)
        try c.encode(address, forKey: .address)
        try c.encode(date,    forKey: .date)
        try c.encode(total,   forKey: .total)       // we always write “total”
        try c.encode(items,   forKey: .items)       // always write “items”
    }


    // Hashable - Equatable zaten orderId ile
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.orderId == rhs.orderId }
    func hash(into h: inout Hasher) { h.combine(orderId) }
}


struct OrderListResponse: Codable {
    let orders: [OrderResponse]
}
