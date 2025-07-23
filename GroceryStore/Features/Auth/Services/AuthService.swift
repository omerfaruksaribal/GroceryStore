import Foundation
import OSLog

struct AuthService {
    private let api = APIClient.shared

    // MARK: - Login
    func login(username: String, password: String) async throws {
        let req = LoginRequest(username: username, password: password)
        typealias Wrapped = ApiResponse<LoginResponse>
        let wrapped: Wrapped = try await api.send(AuthEndpoint.login(req))

        // 1) HTTP status 2xx değilse ama server JSON döndüyse
        guard (200..<300).contains(wrapped.status) else {
            throw APIError.server(message: wrapped.message, code: wrapped.status)
        }

        guard let data = wrapped.data else {
            throw APIError.status(wrapped.status)
        }

        await AuthStore.shared.storeTokens(access: data.accessToken,
                                           refresh: data.refreshToken, username: data.username)
        Log.network.debug("✅ User \(data.username) logged in")
    }

    //  MARK: - Register
    func register(dto: RegisterRequest) async throws -> String {
        typealias Wrapped = ApiResponse<RegisterResponse>
        let wrapped: Wrapped = try await api.send(AuthEndpoint.register(dto))

        guard let data = wrapped.data else {
            throw APIError.status(wrapped.status)
        }

        Log.network.info("✅ Registered \(data.email)")
        return data.message
    }

    //  MARK: - Refresh
    func refreshIfNeeded() async -> Bool {
        guard let shared = await AuthStore.shared.refreshToken else { return false }

        do {
            typealias Wrapped = ApiResponse<RefreshTokenResponse>
            let wrapped: Wrapped = try await api.send(AuthEndpoint.refresh(shared))

            guard let data = wrapped.data else { return false }

            let user = await AuthStore.shared.currentUsername ?? ""

            await AuthStore.shared.storeTokens(access: data.accessToken, refresh: data.refreshToken, username: user)

            return true
        } catch {
            Log.network.error("🔄 Refresh failed: \(error.localizedDescription, privacy: .public)")
            await AuthStore.shared.clearTokens()
            return false
        }
    }

    //  MARK: - Activate
    func activate(email: String, code: String) async throws -> String {
         let dto = ActivateAccountRequest(email: email, activationCode: code)
         typealias Wrapped = ApiResponse<String>   // data *may* be nil

         let wrapped: Wrapped = try await api.send(AuthEndpoint.activate(dto))

         if let msgInData = wrapped.data {
             Log.network.info("✅ Account activated for \(email)")
             return msgInData
         } else if (200..<300).contains(wrapped.status) {
             Log.network.info("✅ Account activated for \(email) (message-only)")
             return wrapped.message
         } else {
             throw APIError.status(wrapped.status)
         }
     }
}
