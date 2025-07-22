import Observation
import Foundation

final class OrdersVM: ObservableObject {
    @Published private(set) var orders: [OrderResponse] = []
    @Published private(set) var isLoading = false
    var error: String?

    private let service = OrderService()

    @MainActor
    func load() async {
        guard !isLoading else { return }
        isLoading = true
        do {
            orders = try await service.fetchAll()
            error = nil
        } catch let APIError.server(message: msg, _) {
            error = msg
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
