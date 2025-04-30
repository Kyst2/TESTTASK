import Foundation
import SwiftUI

class RegistrationViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var selectedPositionId: Int?
    @Published var photo: UIImage?
    
    @Published var positions: [Position] = []
    @Published var isLoading: Bool = false
    @Published var isRegistering: Bool = false
    @Published var errorMessage: String?
    @Published var registrationSuccessful: Bool = false
    
    @Published var nameError: String?
    @Published var emailError: String?
    @Published var phoneError: String?
    @Published var photoError: String?
    
    init() {
        loadPositions()
    }
    
    func loadPositions() {
        isLoading = true
        errorMessage = nil
        
        APIClient.shared.getPositions { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    self?.positions = response.positions
                    
                    if let firstPositionId = response.positions.first?.id {
                        self?.selectedPositionId = firstPositionId
                    }
                    
                case .failure(let error):
                    self?.errorMessage = "Error when uploading posts: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func registerUser() {
        guard validateName() && validateEmail() && validatePhone() else {
            return
        }
        
        guard let photo = photo else {
            return
        }
        
        guard let positionId = selectedPositionId else {
            return
        }
        
        isRegistering = true
        
        let userData = UserRegistrationModel(
            name: name,
            email: email,
            phone: phone,
            positionId: positionId
        )
        
        APIClient.shared.registerUser(user: userData, avatar: photo) { [weak self] result in
            DispatchQueue.main.async {
                self?.isRegistering = false
                
                switch result {
                case .success(let message):
                    self?.registrationSuccessful = true
                    
                    self?.resetForm()
                case .failure(let error):
                    self?.errorMessage = "Registration error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func resetForm() {
        name = ""
        email = ""
        phone = ""
        photo = nil
        errorMessage = nil
    }
}

extension RegistrationViewModel {
    func validateName() -> Bool {
        if name.isEmpty {
            nameError = "Name is required."
            return false
        } else if name.count < 2 || name.count > 60 {
            nameError = "Name must be between 2 and 60 characters."
            return false
        }
        return true
    }
    
    func validateEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: email) {
            emailError = "Invalid email format."
            return false
        }
        
        return true
    }
    
    func validatePhone() -> Bool {
        let regex = #"^\+38(?:\d{9}|\(\d{3}\)\s\d{3}\s-\s\d{2}\s-\s\d{2})$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: phone) {
            phoneError = "Phone must be in format +38(XXX) XXX - XX - XX."
            return false
        }
        return true
    }
        
    func validatePhoto() -> Bool {
        if photo == nil {
            photoError = "Please select a photo."
            return false
        }
        
        return true
    }
}
