import Observation
import Foundation

@Observable
final class LoginVM {
    var username = ""
    var password = ""

    var isLoading = false
    var error: String?

    private let service = AuthService()

    @MainActor
    func submit() async {
        guard validate() else { return }
        isLoading = true
        do {
            try await service.login(username: username, password: password)
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    private func validate() -> Bool {
        if username.isEmpty || password.isEmpty {
            error = "Username and password are required."
            return false
        }
        return true
    }
}
