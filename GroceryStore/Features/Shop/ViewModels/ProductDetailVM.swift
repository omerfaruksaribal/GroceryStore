import Foundation
import Observation

@Observable
final class ProductDetailVM {
    // MARK: - Published State
    private(set) var product: Product?
    private(set) var isLoading = false
    var errorMessage: String?

    // MARK: - Dependencies
    private let service = ProductService()

    // MARK: - API
    @MainActor
    func load(id: String) async {
        guard !isLoading else { return }
        isLoading = true
        do {
            product = try await service.fetchDetail(id: id)
            errorMessage = nil
        } catch let APIError.server(message, _) {
            errorMessage = message
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
