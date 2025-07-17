import Foundation

enum AuthEndpoint {
    case login(LoginRequest)
    case register(RegisterRequest)
    case refresh(String)
    case activate(ActivateAccountRequest)
    case forgotPassword(ForgotPasswordRequest)
    case resetPassword(ResetPasswordRequest)

    //  MARK: - Endpoint
    var path: String {
        switch self {
        case .login:           "/auth/login"
        case .register:        "/auth/register"
        case .refresh:         "/auth/refresh-token"
        case .activate:        "/auth/activate"
        case .forgotPassword:  "/auth/forgot-password"
        case .resetPassword:   "/auth/reset-password"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .register, .refresh, .forgotPassword: return .POST
        case .activate, .resetPassword: return .PATCH
        }
    }

    var body: Data? {
        switch self {
        case .login(let req): try? JSONEncoder().encode(req)
        case .register(let req): try? JSONEncoder().encode(req)
        case .refresh(let token): try? JSONEncoder().encode(RefreshTokenRequest(refreshToken: token))
        case .activate(let req): try? JSONEncoder().encode(req)
        case .forgotPassword(let req): try? JSONEncoder().encode(req)
        case .resetPassword(let req): try? JSONEncoder().encode(req)
        }
    }

    var headers: [String: String] { ["Content-Type": "application/json"] }

    var query: [URLQueryItem] { [] }
}
