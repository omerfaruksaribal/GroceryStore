import Foundation

enum AuthEndpoint: Endpoint {
    case login(LoginRequest)
    case register(RegisterRequest)
    case refresh(String)                 // refreshToken
    case activate(ActivateAccountRequest)
    case forgotPassword(ForgotPasswordRequest)
    case resetPassword(ResetPasswordRequest)

    // MARK: - Endpoint protocol

    var path: String {
        switch self {
        case .login:          "/auth/login"
        case .register:       "/auth/register"
        case .refresh:        "/auth/refresh-token"
        case .activate:       "/auth/activate"
        case .forgotPassword: "/auth/forgot-password"
        case .resetPassword:  "/auth/reset-password"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .register, .refresh, .forgotPassword: return .POST
        case .activate, .resetPassword: return .PATCH
        }
    }

    /// Bu property **şart**; boşsa `[]` döndür
    var query: [URLQueryItem] { [] }

    /// Header dizisi de **şart**; JSON gönderiyoruz
    var headers: [String : String] { ["Content-Type": "application/json"] }

    /// Gövde – ilgili DTO’yu JSON’a çeviriyoruz
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .login(let req):              return try? encoder.encode(req)
        case .register(let req):           return try? encoder.encode(req)
        case .refresh(let token):          return try? encoder.encode(RefreshTokenRequest(refreshToken: token))
        case .activate(let req):           return try? encoder.encode(req)
        case .forgotPassword(let req):     return try? encoder.encode(req)
        case .resetPassword(let req):      return try? encoder.encode(req)
        }
    }
}
