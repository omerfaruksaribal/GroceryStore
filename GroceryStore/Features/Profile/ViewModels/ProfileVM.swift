import Observation
import Foundation
import Combine

final class ProfileVM: ObservableObject  {
    @Published private(set) var profile: ProfileDTO?
    @Published private(set) var isLoading = false
    @Published var error: String?

    private let service = ProfileService()

    @MainActor
    func load() async {
        guard !isLoading else { return }
        isLoading = true

        do {
            profile = try await service.fetch()
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    func update(username: String, password: String) async {
        isLoading = true
        do {
            try await service.update(username: username, password: password)
            // Backend “profil güncellendi, tekrar giriş yap” diyor
            AuthStore.shared.clearTokens()
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    func logout() {
        AuthStore.shared.clearTokens()
    }
}
