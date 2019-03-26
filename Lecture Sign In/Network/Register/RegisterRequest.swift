struct RegisterRequest: Codable {
    let id: String
    let password: String
    let role = "student"
}
