import Foundation

enum ProductEndpoint: Endpoint {
    case list(offset: Int, limit: Int)
    case detail(id: String)

    var path: String {
        switch self {
        case .list:         "/products"
        case .detail(let id): "/products/\(id)"
        }
    }

    var method: HTTPMethod { .GET }

    var query: [URLQueryItem] {
        switch self {
        case .list(let offset, let limit):
            return [URLQueryItem(name: "offset", value: "\(offset)"),
                    URLQueryItem(name: "limit",  value: "\(limit)")]
        case .detail:
            return []
        }
    }

    var headers: [String : String] { [:] }
    var body: Data? { nil }
}
