import SwiftUI

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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
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
