import Foundation

enum ProfileEndpoint: Endpoint {
    /// GET /users/profile
    case me
    /// PATCH /users/profile
    case update(username: String, password: String)

    var path: String { "/users/profile" }

    var method: HTTPMethod {
        switch self {
        case .me: .GET
        case .update: .PATCH
        }
    }

    var query: [URLQueryItem] { [] }

    var headers: [String : String] {
        switch self {
        case .update: ["Content-Type": "application/json"]
        default: [:]
        }
    }

    var body: Data? {
        switch self {
        case .update(let username, let password):
            return try? JSONEncoder().encode(["username": username, "password": password])
        default:
            return nil
        }
    }

}
