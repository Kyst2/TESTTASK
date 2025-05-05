import SwiftUI

struct UsersListView: View {
    @ObservedObject var model: UsersViewModel = UsersViewModel()
    
    var body: some View {
        if model.users.isEmpty {
            ResultModalView(imageName: "noUsers", title: "There are no users yet", buttonText: nil) {}
        } else {
            ScrollView{
                LazyVStack {
                    ForEach(model.users) { user in
                        UserCardView(user: user)
                            .onAppear{
                                model.loadMoreUsersIfNeeded(currentUser: user)
                            }
                    }
                    
                    if model.isLoading {
                        ProgressView()
                            .padding()
                    }
                }
            }
        }
    }
}

