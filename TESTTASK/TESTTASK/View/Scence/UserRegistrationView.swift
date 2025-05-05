import SwiftUI
import PhotosUI

struct UserRegistrationView: View {
    @ObservedObject var model = RegistrationViewModel()
    
    @State private var showingImagePicker = false
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var image: UIImage?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                PersonalData()
                
                PositionalsRadioGroup()
                
                SelectPhotoView(model: model)
                
                SignUpBtn()
            }
            .padding(.vertical, 32)
            .padding(.horizontal, 16)
        }
        .fullScreenCover(item: $model.result, content: { result in
            switch result {
                case .success:
                    ResultModalView(
                        imageName: "successImg",
                        title: "User successfully registered",
                        buttonText: "Got it"
                    ) {
                        model.result = nil
                    }
                case .emailTaken:
                    ResultModalView(
                        imageName: "emailErrorImg",
                        title: "That email is already registered",
                        buttonText: "Try again"
                    ) {
                        model.result = nil
                    }
                }
        })
    }
    
    @ViewBuilder
    func PersonalData() -> some View {
        VStack(spacing: 32) {
            FloatingLabelTextField(label: "Your name",
                                   text: $model.name,
                                   errorText: $model.nameError,
                                   supportingText: nil)
            
            FloatingLabelTextField(label: "Email",
                                   text: $model.email,
                                   errorText: $model.emailError,
                                   supportingText: nil)
            
            FloatingLabelTextField(label: "Phone",
                                   text: $model.phone,
                                   errorText: $model.phoneError,
                                   supportingText: "+38 (XXX) XXX - XX - XX")
        }
    }
    
    @ViewBuilder
    func PositionalsRadioGroup() -> some View {
        VStack(alignment : .leading, spacing: 12) {
            Text("Select your position")
                .font(.nunoRegular(size: 18))
                .foregroundStyle(.black.opacity(0.87))
            
            if !model.positions.isEmpty {
                RadioButtonGroupView(model: model)
            } else if model.isLoading {
                ProgressView()
                    .padding()
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    func SignUpBtn() -> some View {
        HStack{
            Spacer()
            
            Button {
                model.registerUser()
            } label: {
                Text("Sign Up")
            }
            .buttonStyle(PrimaryButtonStyle(isEnabled: isEnabled()))
            
            Spacer()
        }
    }
    
    func isEnabled() -> Bool {
        return !model.email.isEmpty || !model.name.isEmpty || !model.phone.isEmpty
    }
}
