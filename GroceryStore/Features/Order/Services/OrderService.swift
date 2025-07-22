struct OrderService {
    private let api = APIClient.shared

    func place(address: String) async throws -> OrderResponse {
        typealias Wrapped = ApiResponse<OrderResponse>
        let wrapped: Wrapped = try await api.send(OrdersEndpoint.place(address: address))

        guard let data = wrapped.data else { throw APIError.status(wrapped.status) }
        return data
    }

    func fetchAll() async throws -> [OrderResponse] {
        typealias Wrapped = ApiResponse<OrderListResponse>
        let wrapped: Wrapped = try await api.send(OrdersEndpoint.list)

        return wrapped.data?.orders ?? []
    }

    func fetch(id: String) async throws -> OrderResponse {
        typealias Wrapped = ApiResponse<OrderResponse>
        let w: Wrapped = try await api.send(OrdersEndpoint.detail(id: id))

        guard let data = w.data else { throw APIError.status(w.status) }
        return data
    }
}
