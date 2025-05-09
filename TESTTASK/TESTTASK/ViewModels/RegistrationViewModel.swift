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
    
    @Published var nameError: String?
    @Published var emailError: String?
    @Published var phoneError: String?
    @Published var photoError: String?
    
    @Published var result: RegistrationResult?
    
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
        guard validateAll() else {
            return
        }
        
        guard let photo = photo, let positionId = selectedPositionId else { return }
        
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
                case .success:
                    self?.result = .success
                    
                    self?.resetForm()
                case .failure(let error):
                    if let error = error as? NSError {
                        if error.code == 409 {
                            self?.result = .emailTaken
                        } else {
                            self?.errorMessage = "Registration error: \(error.localizedDescription)"
                        }
                    } else {
                        self?.errorMessage = "Unknown error: \(error.localizedDescription)"
                    }
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
    func validateAll() -> Bool {
        let isNameValid = validateName()
        let isEmailValid = validateEmail()
        let isPhoneValid = validatePhone()
        let isPhotoValid = validatePhoto()

        return isNameValid && isEmailValid && isPhoneValid && isPhotoValid
    }
    
    func validateName() -> Bool {
        if name.isEmpty {
            nameError = "Name is required."
            return false
        } else if name.count < 2 || name.count > 60 {
            nameError = "Name must be between 2 and 60 characters."
            return false
        }
        
        nameError = nil
        return true
    }
    
    func validateEmail() -> Bool {
        let regex = #"^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        if !predicate.evaluate(with: email) {
            emailError = "Invalid email format. Use only lowercase letters."
            return false
        }
        
        emailError = nil
        return true
    }
    
    func validatePhone() -> Bool {
        let regex = #"^\+?380[0-9]{9}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: phone) {
            phoneError = "Phone must be in format +38(0XX) XXX - XX - XX."
            return false
        }
        
        phoneError = nil
        return true
    }
        
    func validatePhoto() -> Bool {
        if photo == nil {
            photoError = "Please select a photo."
            return false
        }
        
        photoError = nil
        return true
    }
}

enum RegistrationResult: Identifiable {
    case success
    case emailTaken

    var id: Int {
        switch self {
        case .success: return 0
        case .emailTaken: return 1
        }
    }
}
