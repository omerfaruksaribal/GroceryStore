import Foundation

enum OrderEndpoint: Endpoint {
    case place(address: String)
    case list
    case detail(id: String)

    var path: String {
        switch self {
        case .place, .list: "/orders"
        case .detail(let id): "/orders/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .place: .POST
        case .list, .detail: .GET
        }
    }

    var query: [URLQueryItem] { [] }

    var headers: [String : String] {
        switch self {
        case .place: ["Content-Type": "application/json"]
        default: [:]
        }
    }
    
    var body: Data? {
        switch self {
        case .place(let address):
            return try? JSONEncoder().encode(["address": address])
        default:
            return nil
        }
    }
}
