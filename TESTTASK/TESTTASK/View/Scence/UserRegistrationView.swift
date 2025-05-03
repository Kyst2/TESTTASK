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





