struct RegisterResponse: Codable {
    let userId: String      
    let email: String
    let message: String      // "Registration successful. Please activate…"
}
