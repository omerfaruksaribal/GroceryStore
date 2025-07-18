import Observation
import OSLog
import SwiftUI

@MainActor
@Observable
final class AuthStore {
    //  MARK: - singleton
    static let shared = AuthStore()
    private init() {            // App açılışında refresh token’i Keychain’den, access’i UserDefaults’tan al
        self.accessToken = UserDefaults.standard.string(forKey: Self.accessTokenKey)
        self.refreshToken = KeychainStore.readRefreshToken()
    }

    var accessToken: String?
    private(set) var refreshToken: String?

    // Access token’ın UserDefaults anahtarı
    private static let accessTokenKey = "accessToken"

    //  MARK: - mutating helpers
    /// login sonrası çağrılır
    @MainActor
    func storeTokens(access: String, refresh: String) {
        // RAM + UserDefaults
        accessToken = access
        UserDefaults.standard.set(access, forKey: Self.accessTokenKey)

        // Keychain
        KeychainStore.saveRefreshToken(refresh)
        refreshToken = refresh
    }

    /// Logout
    @MainActor
    func clearTokens() {
        accessToken = nil
        UserDefaults.standard.removeObject(forKey: Self.accessTokenKey)

        KeychainStore.deleteRefreshToken()
        refreshToken = nil
    }
}
