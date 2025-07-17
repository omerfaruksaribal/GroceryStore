struct ApiResponse<T: Codable>: Codable {
    let status: Int
    let message: String
    let data: T?
    let timestamp: String
    let errors: [ErrorDetail]?
}

struct ErrorDetail: Codable {
    let field: String?
    let errorMessage: String
    let rejectedValue: String?
}
