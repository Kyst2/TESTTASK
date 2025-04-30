import SwiftUI

struct CustomRadioGroupView: View {
    @ObservedObject var model: RegistrationViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            ForEach(model.positions) { position in
                CustomRadioButton(label: position.name, value: position.id, selection: $model.selectedPositionId)
            }
        }
    }
}

struct CustomRadioButton<T: Hashable>: View {
    let label: String
    let value: T
    @Binding var selection: T

    var isSelected: Bool {
        selection == value
    }

    var body: some View {
        HStack {
            Image(systemName: isSelected ? "record.circle.fill" : "circle")
                .foregroundColor(isSelected ? TTColors.secondary : Color.black.opacity(0.48))
                .frame(width: 14, height: 14)
                .padding(.horizontal,17)
            
            Text(label)
                .font(.nunoRegular(size: 16))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .onTapGesture {
            selection = value
        }
    }
}
