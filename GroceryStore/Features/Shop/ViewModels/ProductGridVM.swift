import Observation
import Foundation

@Observable
final class ProductGridVM: ObservableObject {
    // UI State
    private(set) var products: [Product] = []
    private(set) var isLoadingPage = false
    private(set) var reachedEnd = false
    var errorMessage: String?

    // Pagination
    private let service = ProductService()
    private var offset = 0
    private var limit = 10

    @MainActor
    func refresh() async {
        offset = 0
        reachedEnd = false
        products.removeAll()
        await loadNextPage()
    }

    @MainActor
    func loadNextPage() async {
        guard !isLoadingPage && !reachedEnd else { return }
        isLoadingPage = true
        do {
            let page = try await service.fetchPage(offset: offset, limit: limit)

            products.append(contentsOf: page.products)
            reachedEnd = (page.currentPage + 1) >= page.totalPages
            offset += limit
            errorMessage = nil
        } catch let APIError.server(message, _) {
            errorMessage = message
        } catch {
            print("❌ pagination error:", error.localizedDescription)
            errorMessage = error.localizedDescription
        }
        isLoadingPage = false
    }
}
