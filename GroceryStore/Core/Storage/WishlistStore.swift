import Foundation
import OSLog

@MainActor
final class WishlistStore: ObservableObject {
    static let shared = WishlistStore()
    private init() {}

    // ----- Published state -----
    @Published private(set) var items: [WishlistItem] = []
    @Published private(set) var isLoading = false
    @Published var error: String? = nil

    // ----- Dependencies -----
    private let service = WishlistService()

    // MARK: - API

    /// Sunucudaki güncel wishlist’i çeker.
    func sync() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            items = try await service.fetch()
            error = nil
        } catch {
            self.error = error.localizedDescription
            Log.network.error("Wishlist fetch failed: \(error.localizedDescription, privacy: .public)")
        }
    }

    /// If the product is already in whislist, then removes; if not then adds.
    func toggle(product: Product) async {
        if items.contains(where: { $0.id == product.id }) {
            await remove(productId: product.id)
        } else {
            await add(productId: product.id)
        }
    }

    /// Adds a wishlisht
    func add(productId: String) async {
        do {
            items = try await service.add(productId: productId)
        } catch {
            Log.network.error("Wishlist add error: \(error.localizedDescription, privacy: .public)")
        }
    }

    /// Removes single wishlist
    func remove(productId: String) async {
        do {
            items = try await service.remove(productId: productId)
        } catch {
            Log.network.error("Wishlist remove error: \(error.localizedDescription, privacy: .public)")
        }
    }

    /// Clears whole wishlist
    func clear() async {
        do {
            try await service.clear()
            items = []
        } catch {
            Log.network.error("Wishlist clear error: \(error.localizedDescription, privacy: .public)")
        }
    }
}
