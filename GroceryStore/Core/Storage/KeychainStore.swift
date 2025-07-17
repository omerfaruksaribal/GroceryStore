import Security
import Foundation

enum KeychainStore {
    /// namespace anahtarı - tek bir yerden yönetim
    private static let refreshTokenKey = "com.grocerystore.refreshToken"

    ///  kaydet / güncelle
    @discardableResult
    static func saveRefreshToken(_ token: String) -> Bool {
        let data = Data(token.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: refreshTokenKey,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        if SecItemCopyMatching(query as CFDictionary, nil) == errSecSuccess {
            let attrsToUpdate = [kSecValueData as String: data]
            return SecItemUpdate(query as CFDictionary, attrsToUpdate as CFDictionary) == errSecSuccess
        }

        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }

    /// okuma
    static func readRefreshToken() -> String? {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: refreshTokenKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        return token
    }

    /// Silme
    @discardableResult
    static func deleteRefreshToken() -> Bool {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: refreshTokenKey
        ]
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
