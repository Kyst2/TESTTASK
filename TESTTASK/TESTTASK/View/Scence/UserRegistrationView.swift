import SwiftUI
import PhotosUI

struct UserRegistrationView: View {
    @ObservedObject var model = RegistrationViewModel()
    
    @State private var showingImagePicker = false
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var image: UIImage?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                PersonalData()
                
                PositionalsRadioGroup()
                
                SelectPhotoView(model: model)
                
                SignUpBtn()
            }
            .padding(.top, 32)
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
                              supportingText: "+38(XXX) XXX - XX - XX")
    }
    
    @ViewBuilder
    func PositionalsRadioGroup() -> some View {
        Text("Select your position")
            .font(.nunoRegular(size: 18))
            .foregroundStyle(.black.opacity(0.87))
        
        if !model.positions.isEmpty {
            RadioButtonGroupView(model: model)
                .padding(.top,-12)
        } else if model.isLoading {
            ProgressView()
                .padding()
                .frame(maxWidth: .infinity)
        }
    }
    
    func SignUpBtn() -> some View {
        Button {
            model.registerUser()
        } label: {
            HStack{
                Text("Sign Up")
                    
            }
        }

    }
}

struct ResultModalView: View {
    var imageName: String
    var title: String
    var buttonText: String
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)

            Text(title)
                .font(.nunoRegular(size: 20))
                .foregroundStyle(Color.black.opacity(0.87))

            actionButton()
        }
        .background(Color.white)
        .padding()
    }
    
    func actionButton() -> some View {
        Button {
            onDismiss()
        } label: {
            Text(buttonText)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .foregroundStyle(Color.black.opacity(0.87))
                .background{
                    RoundedRectangle(cornerRadius: 24).fill(TTColors.primary)
                }
        }
    }
}




