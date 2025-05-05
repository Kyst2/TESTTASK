import SwiftUI

struct UserCardView: View {
    let user: User
    
    @State private var image: UIImage?
    @State private var isLoading = true
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                IsLoading()
                
                Photo()
            }
            
            PersonalInfo()
        }
        .padding(.top, 14)
        .padding(.horizontal, 16)
        .onAppear{
            loadImage()
        }
    }
    
    func PersonalInfo() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(user.name)
                .foregroundStyle(.black.opacity(0.87))
                .font(.nunoRegular(size: 18))
                .lineLimit(3)
            
            Text(user.position)
                .foregroundStyle(.black.opacity(0.6))
                .font(.nunoRegular(size: 14))
                .padding(.bottom,4)
            
            Text(user.email)
                .foregroundStyle(.black.opacity(0.87))
                .font(.nunoRegular(size: 14))
            
            Text(user.phone)
                .foregroundStyle(.black.opacity(0.87))
                .font(.nunoRegular(size: 14))
                .padding(.bottom, 19)
            
            Divider()
        }
    }
    
    @ViewBuilder
    func IsLoading() -> some View {
        if isLoading {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                )
        }
    }
    
    @ViewBuilder
    func Photo() -> some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
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
