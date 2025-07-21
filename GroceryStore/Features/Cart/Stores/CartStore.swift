import Observation
import OSLog

@Observable
final class CartStore: ObservableObject {
    static let shared = CartStore()
    private init() { /* launch’ta fetchCart çağıracağız */ }

    // state
    private(set) var items: [CartItem] = []
    private(set) var total: Double = 0

    // service
    private let service = CartService()

    // MARK: - Mutations
    @MainActor
    func syncFromBackend() async {
        do {
            let page = try await service.fetchCart()
            apply(page)
        } catch {
            Log.network.error("🛒 sync error \(error.localizedDescription, privacy: .public)")
        }
    }

    @MainActor
    func add(product: Product, qty: Int = 1) async {
        do {
            let page = try await service.add(productId: product.id, qty: qty)
            apply(page)
        } catch {
            Log.network.error("add cart fail \(error)")
        }
    }

    @MainActor
    func update(item: CartItem, qty: Int) async {
        do {
            apply(try await service.update(productId: item.productId, qty: qty))
        } catch {
            Log.network.error("update cart fail \(error)")
        }
    }

    @MainActor
    func remove(item: CartItem) async {
        do {
            apply(try await service.remove(productId: item.productId))
        } catch {
            Log.network.error("remove cart fail \(error)")
        }
    }

    @MainActor
    func clear() async {
        do {
            apply(try await service.clear())
        } catch {
            Log.network.error("clear cart fail \(error)")
        }
    }

    @MainActor
    func checkOut(address: String) async -> OrderResponse? {
        guard !items.isEmpty else { return nil }
        do {
            let order = try await OrderService().place(address: address)
            // clear the cart
            items = []
            total = 0
            return order
        } catch {
            Log.network.error("Checkout Failed \(error)")
            return nil
        }
    }

    // helper
    private func apply(_ page: CartPage) {
        items = page.cartItems
        total = page.totalPrice
    }
}
