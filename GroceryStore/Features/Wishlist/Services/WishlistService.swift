struct WishlistService {
    private let api = APIClient.shared

    // MARK: - GET /wishlist
    func fetch() async throws -> [WishlistItem] {
        typealias Wrapped = ApiResponse<WishlistResponse?>
        let wrapped: Wrapped = try await api.send(WishlistEndpoint.list)
        // 2xx kontrolü istersek ekleyebiliriz
        return wrapped.data??.wishlist ?? []
    }

    // MARK: - POST /wishlist   (.add)
    func add(productId: String) async throws -> [WishlistItem] {
        typealias Wrapped = ApiResponse<WishlistResponse?>
        let wrapped: Wrapped = try await api.send(WishlistEndpoint.add(productId: productId))

        guard (200..<300).contains(wrapped.status) else {
            throw APIError.server(message: wrapped.message, code: wrapped.status)
        }
        return wrapped.data??.wishlist ?? []
    }

    // MARK: - DELETE /wishlist/{id}
    func remove(productId: String) async throws -> [WishlistItem] {
        typealias Wrapped = ApiResponse<WishlistResponse?>
        let wrapped: Wrapped = try await api.send(WishlistEndpoint.remove(productId: productId))
        return wrapped.data??.wishlist ?? []
    }

    // MARK: - DELETE /wishlist   (clear)
    func clear() async throws {
        _ = try await api.send(WishlistEndpoint.clear) as ApiResponse<EmptyDTO>
    }
}

private struct EmptyDTO: Codable {}
