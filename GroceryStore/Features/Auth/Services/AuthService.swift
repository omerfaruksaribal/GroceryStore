import Foundation
import OSLog

struct AuthService {
    private let api = APIClient.shared

    //  MARK: - Login
    func login(username: String, password: String) async throws {
        let req = LoginRequest(username: username, password: password)
        typealias Wrapped = ApiResponse<LoginResponse>

        let wrapped: Wrapped = try await api.send(AuthEndpoint.login(req))

        guard let data = wrapped.data else {
            throw APIError.status(wrapped.status)
        }

        AuthStore.shared.storeTokens(access: data.accesstoken, refresh: data.refreshToken)

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
        guard let shared = AuthStore.shared.refreshToken else { return false }

        do {
            typealias Wrapped = ApiResponse<RefreshTokenResponse>
            let wrapped: Wrapped = try await api.send(AuthEndpoint.refresh(shared))

            guard let data = wrapped.data else { return false }
            await AuthStore.shared.storeTokens(access: data.accessToken, refresh: data.refreshToken)

            return true
        } catch {
            Log.network.error("🔄 Refresh failed: \(error.localizedDescription, privacy: .public)")
            await AuthStore.shared.clearTokens()
            return false
        }
    }
}
