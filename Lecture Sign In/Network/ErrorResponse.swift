struct ErrorResponse: Error, Codable {
    let error: String
    
    var localizedDescription: String {
        return error
    }
}
