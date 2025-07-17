import Foundation
import Observation

@Observable
final class RegisterVM {
    var username = ""
    var email = ""
    var password = ""

    var isLoading = false
    var successMessage: String?
    var error: String?

    private let service = AuthService()

    @MainActor
    func submit() async {
        guard validate() else { return }
        isLoading = true
        do {
            let dto = RegisterRequest(username: username, email: email, password: password)
            successMessage = try await service.register(dto: dto)
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    private func validate() -> Bool {
        if username.count < 3 {
            error = "Username must be at least 3 characters."
            return false
        }
        if !email.contains("@") {
            error = "Invalid email!"
            return false
        }
        if password.count < 8 {
            error = "Password must be at least 8 characters."
            return false
        }
        return true
    }
}
