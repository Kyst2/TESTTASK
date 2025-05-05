import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var isEnabled: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed

        return configuration.label
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(backgroundColor(isPressed: isPressed, isEnabled: isEnabled))
            )
            .foregroundColor(foregroundColor(isEnabled: isEnabled))
            .font(.nunoRegular(size: 18))
            .disabled(isEnabled)
    }

    private func backgroundColor(isPressed: Bool, isEnabled: Bool) -> Color {
        if !isEnabled {
            return TTColors.gray
        } else if isPressed {
            return TTColors.btnPres
        } else {
            return TTColors.primary
        }
    }

    private func foregroundColor(isEnabled: Bool) -> Color {
        return isEnabled ? Color.black.opacity(0.87) : Color.black.opacity(0.48)
    }
}
