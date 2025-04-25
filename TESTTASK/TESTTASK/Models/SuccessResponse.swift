import Foundation

// MARK: model of successful response from the API
struct SuccessResponse: Codable {
    let success: Bool
    let message: String
    let userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, message
        case userId = "user_id"
    }
}

// MARK: model of error response from the API
struct ErrorResponse: Codable {
    let success: Bool
    let message: String
}

