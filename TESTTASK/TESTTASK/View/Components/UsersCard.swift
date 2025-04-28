import SwiftUI

struct UsersCard: View {
    let user: User
    
    @State private var image: UIImage?
    @State private var isLoading = true
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 0){
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
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .foregroundStyle(.black.opacity(0.87))
                    .font(.nunoRegular(size: 18))
                    .lineSpacing(24)
                    .lineLimit(3)
                
                Text(user.position)
                    .foregroundStyle(.black.opacity(0.6))
                    .font(.nunoRegular(size: 14))
                    .lineSpacing(20)
                    .padding(.bottom,4)
                
                Text(user.email)
                    .foregroundStyle(.black.opacity(0.87))
                    .font(.nunoRegular(size: 14))
                    .lineSpacing(20)
                
                Text(user.phone)
                    .foregroundStyle(.black.opacity(0.87))
                    .font(.nunoRegular(size: 14))
                    .lineSpacing(20)
                    .padding(.bottom, 19)
                
                Divider()
            }
        }
        .padding(.top, 14)
        .padding(.horizontal, 16)
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
