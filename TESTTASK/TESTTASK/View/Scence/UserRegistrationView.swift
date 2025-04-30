import SwiftUI
import PhotosUI

struct UserRegistrationView: View {
    @ObservedObject var model = RegistrationViewModel()
    
    @State private var showingImagePicker = false
    
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                RegistrationTextField(label: "Your name", text: $model.name, errorText: $model.nameError, supportingText: nil)
                
                RegistrationTextField(label: "Email", text: $model.email, errorText: $model.emailError,supportingText: nil)
                
                RegistrationTextField(label: "Phone", text: $model.phone, errorText: $model.phoneError, supportingText: "+38(XXX) XXX - XX - XX")
                
                Text("Select your position")
                    .font(.nunoRegular(size: 20))
                
                Picker("", selection: $model.selectedPositionId) {
                }
            }
            .padding(.top, 32)
            .padding(.horizontal, 16)
        }
    }
}

struct RegistrationTextField: View {
    var label: String
    @Binding var text: String
    @Binding var errorText: String?
    let supportingText: String?
    var state: FieldState = .normal

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .leading) {
                Text(label)
                    .foregroundColor(accentColors)
                    .font(.nunoRegular(size: 16))
                    .offset(y: (isFocused || !text.isEmpty) ? -22 : 0)
                    .scaleEffect((isFocused || !text.isEmpty) ? 0.8 : 1, anchor: .leading)
                    .animation(.easeOut(duration: 0.15), value: isFocused || !text.isEmpty)

                TextField("", text: $text)
                    .font(.nunoRegular(size: 16))
                    .focused($isFocused)
                    .padding(.top, 8)
            }
            .padding(12)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(hex: 0xd0cfcf), lineWidth: 1)
            )
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
            )
            
            if let errorText = errorText{
                Text(errorText)
                    .font(.nunoRegular(size: 12))
                    .foregroundStyle(TTColors.red)
            } else if let supportingText = supportingText{
                Text(supportingText)
                    .font(.nunoRegular(size: 12))
                    .foregroundStyle(.black.opacity(0.6))
            }
        }
    }

    private var accentColors: Color {
        switch state {
        case .normal: return isFocused ? TTColors.secondary : Color.black.opacity(0.48)
        case .error: return TTColors.red
        }
    }
}

enum FieldState {
    case normal
    case error(String)
}
