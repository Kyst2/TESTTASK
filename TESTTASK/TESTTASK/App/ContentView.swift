import SwiftUI

struct ContentView: View {
    @State private var selectTab: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            TopBar()
            
            TabView(selection: $selectTab) {
                UsersListView()
                    .tag(0)
                
                UserRegistrationView()
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            BottomBar()
        }
        .background(Color.white)
    }
    
    @ViewBuilder
    func TopBar() -> some View {
        let requestTypeText: String = selectTab == 0 ? "GET" : "POST"
        
        ZStack {
            TTColors.primary
                .frame(height: 56)
            
            Text("Working with \(requestTypeText) request")
                .font(.nunoRegular(size: 20))
                .lineSpacing(24)
        }
    }
    
    func BottomBar() -> some View {
        HStack {
            Spacer()
            
            BottomBarBtn(img: "person.3.sequence.fill", text: "Users", isSelected: selectTab == 0) {
                selectTab = 0
            }
            
            Spacer()
            
            BottomBarBtn(img: "person.crop.circle.fill.badge.plus", text: "Sing up", isSelected: selectTab == 1) {
                selectTab = 1
            }
            
            Spacer()
        }
        .background(TTColors.gray)
    }
}


////////////////
///HELPERS
////////////////

struct BottomBarBtn: View {
    let img: String
    let text: String
    let isSelected: Bool
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: img)
                    .frame(width: 14, height: 14)
                    .foregroundStyle(buttonColor)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
                
                Text(text)
                    .font(.nunoSemiBold(size: 16))
                    .lineSpacing(24)
                    .kerning(0.1)
                    .foregroundStyle(buttonColor)
                    .padding(.leading, 8)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
            .padding(.vertical,16)
        }
    }
    
    private var buttonColor: Color {
        isSelected ? TTColors.secondary : Color.black.opacity(0.6)
    }
}
