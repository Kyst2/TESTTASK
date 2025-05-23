import SwiftUI

enum FieldState {
    case normal
    case error
}

struct FloatingLabelTextField: View {
    var label: String
    @Binding var text: String
    @Binding var errorText: String?
    let supportingText: String?
    
    private var state: FieldState {
        errorText == nil ? .normal : .error
    }
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .leading) {
                Label()
                
                CustomTextField()
            }
            .padding(12)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(accentColors(grayColor: Color(hex: 0xd0cfcf)), lineWidth: 1)
            )
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
            )
            
            ErrorOrSupportText()
        }
    }
    
    func Label() -> some View {
        Text(label)
            .foregroundColor(accentColors(grayColor: Color.black.opacity(0.48)))
            .font(.nunoRegular(size: 16))
            .offset(y: (isFocused || !text.isEmpty) ? -22 : 0)
            .scaleEffect((isFocused || !text.isEmpty) ? 0.8 : 1, anchor: .leading)
            .animation(.easeOut(duration: 0.15), value: isFocused || !text.isEmpty)
    }
    
    func CustomTextField() -> some View {
        TextField("", text: $text)
            .frame(maxWidth: .infinity)
            .font(.nunoRegular(size: 16))
            .foregroundStyle(Color.black.opacity(0.87))
            .focused($isFocused)
            .padding(.top, 8)
    }
    
    @ViewBuilder
    func ErrorOrSupportText() -> some View {
        if let errorText = errorText{
            Text(errorText)
                .font(.nunoRegular(size: 12))
                .foregroundStyle(TTColors.red)
                .padding(.horizontal, 16)
        } else if let supportingText = supportingText{
            Text(supportingText)
                .font(.nunoRegular(size: 12))
                .foregroundStyle(.black.opacity(0.6))
                .padding(.horizontal, 16)
        }
    }
    
    private func accentColors(grayColor: Color) -> Color {
        switch state {
        case .normal: return isFocused ? TTColors.secondary : grayColor
        case .error: return TTColors.red
        }
    }
}
