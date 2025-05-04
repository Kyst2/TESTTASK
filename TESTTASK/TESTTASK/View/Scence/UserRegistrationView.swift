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
                        imageName: "SuccessImage",
                        title: "User successfully registered",
                        buttonText: "Got it"
                    ) {
                        model.result = nil
                    }
                case .emailTaken:
                    ResultModalView(
                        imageName: "ErrorImage",
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
        VStack(spacing: 20) {
            Image(imageName) // вставь свои картинки в Assets с именами "SuccessImage" и "ErrorImage"
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)

            Text(title)
                .font(.headline)

            Button(buttonText) {
                onDismiss()
            }
            .padding()
            .background(Color.yellow)
            .cornerRadius(10)
        }
        .padding()
    }
}




