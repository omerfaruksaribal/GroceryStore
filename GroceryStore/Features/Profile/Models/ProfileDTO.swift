import Foundation

struct ProfileDTO: Codable {
    let username: String
    let email: String
    let password: String?            // backend sends but we dont use
    let cart: [CartItem]?         // may come empty
    let orders: [OrderResponse]?     // may come empty
}
