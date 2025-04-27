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
            }
        }
    }
}

extension View {
    // Если метод refreshable вызывается на iOS 14, мы просто возвращаем исходный вид
    @ViewBuilder
    func onRefreshCompat(perform action: @escaping () -> Void) -> some View {
        if #available(iOS 15.0, *) {
            // На iOS 15+ используем встроенный метод refreshable
            self.refreshable {
                // Выполняем действие обновления
                action()
            }
        } else {
            // На iOS 14 просто возвращаем вид без функциональности pull-to-refresh
            // В реальном приложении здесь можно было бы реализовать собственную логику
            self
        }
    }
}
