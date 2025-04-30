import SwiftUI
import PhotosUI

struct UserRegistrationView: View {
    @ObservedObject var model = RegistrationViewModel()
    
    @State private var showingImagePicker = false
    
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                PersonalData()
                
                PositionalsRadioGroup()
            }
            .padding(.top, 32)
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    func PersonalData() -> some View {
        RegistrationTextField(label: "Your name", text: $model.name, errorText: $model.nameError, supportingText: nil)
        
        RegistrationTextField(label: "Email", text: $model.email, errorText: $model.emailError,supportingText: nil)
        
        RegistrationTextField(label: "Phone", text: $model.phone, errorText: $model.phoneError, supportingText: "+38(XXX) XXX - XX - XX")
    }
    
    @ViewBuilder
    func PositionalsRadioGroup() -> some View {
        Text("Select your position")
            .font(.nunoRegular(size: 18))
            .foregroundStyle(.black.opacity(0.87))
        
        if !model.positions.isEmpty {
            CustomRadioGroupView(model: model)
                .padding(.top,-12)
        } else if model.isLoading {
            ProgressView()
                .padding()
                .frame(maxWidth: .infinity)
        }
    }
}




