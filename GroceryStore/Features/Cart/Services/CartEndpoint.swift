import Foundation

enum CartEndpoint: Endpoint {
    case get
    case add(_ dto: AddItemToCartRequest)
    case update(productId: String, qty: Int)
    case remove(productId: String)
    case clear

    var path: String {
        switch self {
        case .get, .add, .clear:           "/cart"
        case .update(let id, _), .remove(let id): "/cart/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .get:       .GET
        case .add:       .POST
        case .update:    .PATCH
        case .remove:    .DELETE
        case .clear:     .DELETE
        }
    }

    var query: [URLQueryItem] { [] } 

    var headers: [String : String] {
        switch self {
        case .add, .update:            // body ile giden istekler
            return ["Content-Type": "application/json"]
        default:
            return [:]
        }
    }

    var body: Data? {
        switch self {
        case .add(let dto):
            return try? JSONEncoder().encode(dto)
        case .update(_, let qty):
            return try? JSONEncoder().encode(UpdateCartItemRequest(quantity: qty))
        default: return nil
        }
    }
}

// DTO’s
struct AddItemToCartRequest: Codable {
    let productId: String
    let quantity: Int
}
struct UpdateCartItemRequest: Codable {
    let quantity: Int
}

// Response wrapper
struct CartPage: Codable {
    let cartItems: [CartItem]
    let totalPrice: Double
}
