import Foundation

struct ReviewService {
    private let api = APIClient.shared

    func fetch(productId: String) async throws -> [ReviewDTO] {
        typealias Wrapped = ApiResponse<[ReviewDTO]>
        let wrapped: Wrapped = try await api.send(ReviewEndpoint.list(productId: productId))

        return wrapped.data ?? []
    }

    func add(productId: String, rating: Int, comment: String) async throws -> ReviewDTO {
        typealias Wrapped = ApiResponse<ReviewDTO>
        let wrapped: Wrapped = try await api.send(ReviewEndpoint.add(productId: productId, rating: rating, comment: comment))

        guard let data = wrapped.data else { throw APIError.status(wrapped.status) }
        return data
    }

    func delete(productId: String) async throws {
        _ = try await api.send(ReviewEndpoint.delete(productId: productId)) as ApiResponse<EmptyDTO>
    }
}

private struct EmptyDTO: Codable {}
