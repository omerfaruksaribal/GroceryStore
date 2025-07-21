struct CartService {
    private let api = APIClient.shared

    func fetchCart() async throws -> CartPage {
        typealias Wrapped = ApiResponse<CartPage>
        let wrapped: Wrapped = try await api.send(CartEndpoint.get)

        guard let data = wrapped.data else { throw APIError.status(wrapped.status) }
        return data
    }

    func add(productId: String, qty: Int = 1) async throws -> CartPage {
        try await mutate(.add(AddItemToCartRequest(productId: productId, quantity: qty)))
    }

    func update(productId: String, qty: Int) async throws -> CartPage {
        try await mutate(.update(productId: productId, qty: qty))
    }

    func remove(productId: String) async throws -> CartPage {
        try await mutate(.remove(productId: productId))
    }

    func clear() async throws -> CartPage {
        try await mutate(.clear)
    }

    // shared mutate helper
    private func mutate(_ ep: CartEndpoint) async throws -> CartPage {
        typealias Wrapped = ApiResponse<CartPage>
        let wrapped: Wrapped = try await api.send(ep)

        guard let data = wrapped.data else { throw APIError.status(wrapped.status) }
        return data
    }
}
