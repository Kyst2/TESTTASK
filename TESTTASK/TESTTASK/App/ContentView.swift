import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            UsersListView()
            
            BottomBar()
        }
    }
    
    func BottomBar() -> some View {
        HStack {
            Spacer()
            
            BottomBarBtn(img: "person.3.sequence.fill", text: "Users", color: TTColors.secondary) {
                
            }
            
            Spacer()
            
            BottomBarBtn(img: "person.crop.circle.fill.badge.plus", text: "Sing up", color: .black.opacity(0.6)) {
                
            }
            Spacer()
        }
    }
}


////////////////
///HELPERS
////////////////

struct BottomBarBtn: View {
    let img: String
    let text: String
    let color: Color
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: img)
                    .frame(width: 14, height: 14)
                    .foregroundStyle(color)
                    
                
                Text(text)
                    .font(.nunoSemiBold(size: 16))
                    .lineSpacing(24)
                    .kerning(0.1)
                    .foregroundStyle(color)
                    .padding(.leading, 8)
            }
            .padding(.vertical,16)
        }
    }
}
