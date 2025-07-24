import Foundation

enum WishlistEndpoint: Endpoint {
    case list
    case add(productId: String)
    case remove(productId: String)
    case clear

    var path: String {
        switch self {
        case .list, .add, .clear: "/wishlist"
        case .remove(let id):     "/wishlist/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list: .GET
        case .add: .POST
        case .remove: .DELETE
        case .clear: .DELETE
        }
    }

    var query: [URLQueryItem] { [] }

    var headers: [String: String] {
        switch self {
        case .add: ["Content-Type": "application/json"]
        default:   [:]
        }
    }

    var body: Data? {
        guard case let .add(id) = self else { return nil }
        return try? JSONEncoder().encode(["productId": id])
    }
}
