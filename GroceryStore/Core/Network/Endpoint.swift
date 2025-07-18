import Foundation

enum HTTPMethod: String { case GET, POST, PUT, PATCH, DELETE }

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case status(Int)
    case decoding(Error)
    case server(message: String, code: Int)   
}

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var query: [URLQueryItem] { get }
    var headers: [String: String] { get }
    var body: Data? { get }
}

extension Endpoint {
    // we call BASE_URL from .xcconfig
    private var baseURL: URL {
        guard let str = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String,
              let url = URL(string: str) else {
            fatalError("BASE_URL missing in Info.plist")
        }
        return url
    }

    var url: URL {
        var comps = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        comps.queryItems = query.isEmpty ? nil : query

        return comps.url!
    }
}
