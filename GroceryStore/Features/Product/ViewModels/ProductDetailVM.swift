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
    private let reviewService = ReviewService()

    private(set) var reviews: [ReviewDTO] = []

    // MARK: - API
    @MainActor
    func load(id: String) async {
        guard !isLoading else { return }
        isLoading = true
        do {
            product = try await service.fetchDetail(id: id)
            errorMessage = nil
            reviews = try await reviewService.fetch(productId: id)
        } catch let APIError.server(message, _) {
            errorMessage = message
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    //  MARK: - Review
    @MainActor
    func loadReviews(for productId: String) async {
        do {
            reviews = try await reviewService.fetch(productId: productId)
        } catch {
            print("❗️Review fetch error:", error)
        }
    }

    @MainActor
    func addReview(rating: Int, comment: String, productId: String) async {
        do {
            let new = try await reviewService.add(productId: productId, rating: rating, comment: comment)
            reviews.insert(new, at: 0)
        } catch {
            print("❗️Review add error:", error)
        }
    }

    @MainActor
    func deleteMyReview(productId: String) async {
        do {
            try await reviewService.delete(productId: productId)
            if let me = AuthStore.shared.currentUsername {   // AuthStore’da username saklıysa
                reviews.removeAll { $0.username == me }
            }
        } catch {
            print("❗️Review delete error:", error)
        }
    }
}
