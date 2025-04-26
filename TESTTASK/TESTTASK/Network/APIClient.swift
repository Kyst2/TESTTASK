import Foundation
import SwiftUI

class APIClient {
    private let baseURL = "https://frontend-test-assignment-api.abz.agency/api/v1"
    
    private var token: String?
    
    static let shared = APIClient()
    
    private init() {}
    
    func getUsers(page: Int = 1, count: Int = 6, completion: @escaping (Result<UsersResponse, Error>) -> Void) {
        let urlString = "\(baseURL)/users?page=\(page)&count=\(count)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let usersResponse = try decoder.decode(UsersResponse.self, from: data)
                completion(.success(usersResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getPositions(completion: @escaping (Result<PositionsResponse, Error>) -> Void) {
        let urlString = "\(baseURL)/positions"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let positionsResponse = try decoder.decode(PositionsResponse.self, from: data)
                completion(.success(positionsResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getToken(completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        let urlString = "\(baseURL)/token"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
                
                if tokenResponse.success {
                    completion(.success(tokenResponse))
                } else {
                    completion(.failure(URLError(.badServerResponse)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func registerUser(user: UserRegistrationModel, avatar: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        getToken { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let tokenData):
                self.token = tokenData.token
                
                self.performRegistration(user: user, avatar: avatar, token: tokenData.token, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func performRegistration(user: UserRegistrationModel, avatar: UIImage, token: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        guard let avatarData = avatar.jpegData(compressionQuality: 0.7) else {
            completion(.failure(NSError(domain: "APIClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert avatar to JPEG"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        var body = Data()
        
        body.append(textFormField(named: "name", value: user.name, boundary: boundary))
        body.append(textFormField(named: "email", value: user.email, boundary: boundary))
        body.append(textFormField(named: "phone", value: user.phone, boundary: boundary))
        body.append(textFormField(named: "position_id", value: String(user.positionId), boundary: boundary))
        
        body.append(imageFormField(named: "photo", fileName: "avatar.jpg", mimeType: "image/jpeg", data: avatarData, boundary: boundary))
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.unknownError))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let data = data, let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    completion(.failure(NSError(domain: "APIClient", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.message])))
                } else {
                    completion(.failure(APIError.serverError(statusCode: httpResponse.statusCode)))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.unknownError))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(SuccessResponse.self, from: data)
                completion(.success(response.message))
            } catch {
                completion(.failure(APIError.decodingError))
            }
        }
        task.resume()
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}

enum APIError: Error {
    case invalidURL
    case serverError(statusCode: Int)
    case decodingError
    case unknownError
}

extension APIClient {
    func textFormField(named: String, value: String, boundary: String) -> Data {
        var fieldData = Data()
        fieldData.append("--\(boundary)\r\n".data(using: .utf8)!)
        fieldData.append("Content-Disposition: form-data; name=\"\(named)\"\r\n\r\n".data(using: .utf8)!)
        fieldData.append("\(value)\r\n".data(using: .utf8)!)
        return fieldData
    }
    
    func imageFormField(named: String, fileName: String, mimeType: String, data: Data, boundary: String) -> Data {
        var fieldData = Data()
        fieldData.append("--\(boundary)\r\n".data(using: .utf8)!)
        fieldData.append("Content-Disposition: form-data; name=\"\(named)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        fieldData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        fieldData.append(data)
        fieldData.append("\r\n".data(using: .utf8)!)
        return fieldData
    }
}
