import Foundation

struct ProfileService {
    private let api = APIClient.shared

    func fetch() async throws -> ProfileDTO {
        typealias Wrapped = ApiResponse<ProfileDTO>
        let wrapped: Wrapped = try await api.send(ProfileEndpoint.me)

        guard let data = wrapped.data else {
            print("❌ server responded with status \(wrapped.status) but empty data")
            throw APIError.status(wrapped.status)
        }

        return data
    }

    func update(username: String, password: String) async throws {
        typealias Wrapped = ApiResponse<[String:String]>
        _ = try await api.send(ProfileEndpoint.update(username: username, password: password)) as Wrapped
    }
}
