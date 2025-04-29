import SwiftUI
import PhotosUI

struct UserRegistrationView: View {
    @ObservedObject var model = RegistrationViewModel()
    
    @State private var showingImagePicker = false
    
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        ScrollView {
            VStack {
                RegistrationTextField(label: "Name", text: $model.name)
                
            }
            .padding(.top, 32)
            .padding(.horizontal, 16)
        }
    }
}

struct RegistrationTextField: View {
    var label: String
    @Binding var text: String
    var supportingText: String?
    var state: FieldState = .normal

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .leading) {
                Text(label)
                    .foregroundColor(accentColors)
                    .font(.caption)
                    .offset(y: (isFocused || !text.isEmpty) ? -22 : 0)
                    .scaleEffect((isFocused || !text.isEmpty) ? 0.8 : 1, anchor: .leading)
                    .animation(.easeOut(duration: 0.15), value: isFocused || !text.isEmpty)

                TextField("", text: $text)
                    .focused($isFocused)
                    .padding(.top, 8)
            }
            .padding(12)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(accentColors, lineWidth: 1.5)
            )
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
            )
            
            if case .error(let errorText) = state {
                Text(errorText)
                    .font(.caption)
                    .foregroundColor(.red)
            } else if let supporting = supportingText {
                Text(supporting)
                    .font(.caption)
                    .foregroundColor(.gray)
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
