import Foundation

enum ReviewEndpoint: Endpoint {
    case list(productId: String) // GET
    case add(productId: String, rating: Int, comment: String) // POST
    case delete(productId: String) // DELETE

    var path: String {
        switch self {
        case .list(let id), .add(let id, _, _), .delete(let id):
            return "/products/\(id)/reviews"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list:   .GET
        case .add:    .POST
        case .delete: .DELETE
        }
    }

    var query: [URLQueryItem] { [] }

    var headers: [String : String] {
        switch self {
        case .add: ["Content-Type": "application/json"]
        default: [:]
        }
    }

    var body: Data? {
        switch self {
        case .add(_, let rating, let comment):
            let dto = AddReviewRequest(rating: rating, comment: comment)
            return try? JSONEncoder().encode(dto)
        default:
            return nil
        }
    }
}
