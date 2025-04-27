import SwiftUI

struct UsersCard: View {
    let user: User
    
    @State private var image: UIImage?
    @State private var isLoading = true
    var body: some View {
        HStack {
            VStack {
                ZStack {
                    if isLoading {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 50, height: 50)
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            )
                    }
                    
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                }
            }
            
            Text(user.name)
            
            Text(user.position)
            
            Text(user.email)
            
            Text(user.phone)
        }
        .onAppear{
            loadImage()
        }
    }
    
    private func loadImage() {
        isLoading = true
        
        APIClient.shared.loadImage(from: user.photo) { loadedImage in
            DispatchQueue.main.async {
                self.image = loadedImage
                self.isLoading = false
            }
        }
    }
}
