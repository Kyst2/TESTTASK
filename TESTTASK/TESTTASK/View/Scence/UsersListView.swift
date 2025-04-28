import SwiftUI

struct UsersListView: View {
    @ObservedObject var model: UsersViewModel = UsersViewModel()
    
    var body: some View {
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

