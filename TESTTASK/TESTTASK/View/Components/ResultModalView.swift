import SwiftUI

struct ResultModalView: View {
    var imageName: String
    var title: String
    var buttonText: String?
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
    
    @ViewBuilder
    func actionButton() -> some View {
        if let buttonText = buttonText {
            Button {
                onDismiss()
            } label: {
                Text(buttonText)
            }
            .buttonStyle(PrimaryButtonStyle())
        }
    }
}
