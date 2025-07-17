import Foundation
import OSLog

final class APIClient {
    static let shared = APIClient()
    private init() {}

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    /// Generic request  - 'T' response from server
    func send<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        endpoint.headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        /// If there is access token, then set it
        if let token = await AuthStore.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        Log.network.info("➡️ \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }

            Log.network.info("⬅️ \(http.statusCode) bytes:\(data.count, privacy: .public)")

            guard (200..<300).contains(http.statusCode) else {
                throw APIError.status(http.statusCode)
            }

            return try decoder.decode(T.self, from: data)
        } catch let err as DecodingError {
            Log.decoding.error("🛑 Decode error: \(err.localizedDescription, privacy: .public)")
            throw APIError.decoding(err)
        } catch {
            throw error
        }
    }

}
