import SwiftUI

struct UsersListView: View {
    @ObservedObject var model: UsersViewModel = UsersViewModel()
    
    var body: some View {
        VStack {
            TopBar()
            
            UsersList()
        }
    }
    
    func TopBar() -> some View {
        ZStack {
            TTColors.primary
                .frame(height: 56)
            
            Text("Working with GET request")
                .font(.nunoRegular(size: 20))
                .lineSpacing(24)
                .padding(16)
        }
    }
    
    func UsersList() -> some View {
        ScrollView{
            LazyVStack {
                ForEach(model.users) { user in
                    UsersCard(user: user)
                        .onAppear{
                            model.loadMoreUsersIfNeeded(currentUser: user)
                        }
                }
                
                if model.isLoading && !model.users.isEmpty {
                    ProgressView()
                        .padding()
                }
            }
        }
    }
}

