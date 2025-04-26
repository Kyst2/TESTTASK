import Foundation

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    
    @Published var isLoading: Bool = false
    @Published var canLoadingMore: Bool = true
    
    @Published var errorMessage: String?
    
    private var currentPage = 1
    
    private let fixedCount = 6
    
    init() {
        loadUsers()
    }
    
    func loadMoreUsersIfNeeded(currentUser: User) {
        guard let lastUser = users.last else { return }
        if currentUser.id == lastUser.id {
            loadUsers()
        }
    }
    
    func loadUsers() {
        guard !isLoading && canLoadingMore else { return }
        isLoading = true
        errorMessage = nil
        
        APIClient.shared.getUsers(page: currentPage, count: fixedCount) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    if response.users.isEmpty {
                        self?.canLoadingMore = false
                    } else {
                        self?.users.append(contentsOf: response.users)
                        self?.currentPage += 1
                    }
                case .failure(let error):
                    self?.errorMessage = "Error when loading users: \(error.localizedDescription)"
                }
            }
        }
    }
}
