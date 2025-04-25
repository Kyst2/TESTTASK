import Foundation

// MARK: - User model
struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let positionId: Int
    let registrationTimestamp: Int
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, position
        case positionId = "position_id"
        case registrationTimestamp = "registration_timestamp"
        case photo
    }
}

// MARK: - API response model with a list of users
struct UsersResponse: Codable {
    let success: Bool
    let page: Int
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let links: Links
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case success, page, count, users
        case totalPages = "total_pages"
        case totalUsers = "total_users"
        case links
    }
}

// MARK: - Pagination links
struct Links: Codable {
    let nextUrl: String?
    let prevUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case nextUrl = "next_url"
        case prevUrl = "prev_url"
    }
}

// MARK: - Position model
struct Position: Codable, Identifiable {
    let id: Int
    let name: String
}

// MARK: - Response model with a list of positions
struct PositionsResponse: Codable {
    let success: Bool
    let positions: [Position]
}

// MARK: - Response model when a token is received
struct TokenResponse: Codable {
    let success: Bool
    let token: String
}

// MARK: - Response model after registration
struct RegistrationResponse: Codable {
    let success: Bool
    let userId: Int?
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case userId = "user_id"
        case message
    }
}

// MARK: - Registration request model
struct RegistrationRequest: Codable {
    let name: String
    let email: String
    let phone: String
    let positionId: Int
    let photo: Data
    
    enum CodingKeys: String, CodingKey {
        case name, email, phone
        case positionId = "position_id"
        case photo
    }
}

