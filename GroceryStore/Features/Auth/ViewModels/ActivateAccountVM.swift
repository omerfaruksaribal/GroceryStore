import Observation
import Foundation

@Observable
final class ActivateAccountVM {
    let email: String

    init(email: String) { self.email = email }

    var code = ""

    var isLoading = false
    var successMessage: String?
    var error: String?

    private let service = AuthService()

    @MainActor
    func submit() async {
        guard !code.isEmpty else { error = "Kod boş olamaz"; return }
        isLoading = true
        do {
            let msg = try await service.activate(email: email, code: code)
            successMessage = msg
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
