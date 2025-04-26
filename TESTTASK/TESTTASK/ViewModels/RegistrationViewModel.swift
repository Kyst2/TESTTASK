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
    
    @Published var nameValid: Bool = true
    @Published var emailValid: Bool = true
    @Published var phoneValid: Bool = true
    @Published var positionValid: Bool = true
    @Published var photoValid: Bool = true
    
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
    
    func validateForm() -> Bool {
        nameValid = !name.isEmpty && name.count >= 2 && name.count <= 60
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        emailValid = emailPredicate.evaluate(with: email)
        
        let phoneRegex = "^\\+380[0-9]{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        phoneValid = phonePredicate.evaluate(with: phone)
        
        positionValid = selectedPositionId != nil
        
        photoValid = photo != nil
        
        return nameValid && emailValid && phoneValid && positionValid && photoValid
    }
    
    func registerUser() {
        guard validateForm() else {
            errorMessage = "Please fill in all fields correctly"
            return
        }
        
        guard let photo = photo else {
            errorMessage = "Please select a photo."
            return
        }
        
        guard let positionId = selectedPositionId else {
            errorMessage = "Please select a position"
            return
        }
        
        isRegistering = true
        errorMessage = nil
        
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
