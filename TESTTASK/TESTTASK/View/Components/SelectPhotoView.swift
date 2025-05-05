import SwiftUI
import PhotosUI

struct SelectPhotoView: View {
    @ObservedObject var model: RegistrationViewModel
    @State  var image: UIImage?
    @State var selectedItem: PhotosPickerItem?
    
    @State private var isShowDialog: Bool = false
    @State private var isShowPhotoPicker = false
    @State private var isShowCamera = false
    
    private var state: FieldState {
        model.photoError == nil ? .normal : .error
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let photo = model.photo {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70 , height: 70)
                        .clipped()
                } else {
                    Text("Upload your photo")
                        .foregroundColor(accentColors(grayColor: Color.black.opacity(0.48)))
                        .font(.nunoRegular(size: 16))
                }
                
                Spacer()
                
                Button {
                    isShowDialog = true
                } label: {
                    Text("Upload")
                        .foregroundStyle(.blue)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(accentColors(grayColor: Color(hex: 0xd0cfcf)), lineWidth: 1)
            )
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white)
            )
            
            if let errorText = model.photoError{
                Text(errorText)
                    .font(.nunoRegular(size: 12))
                    .foregroundStyle(TTColors.red)
                    .padding(.horizontal, 16)
            }
        }
        .confirmationDialog("Choose how you want to add a photo", isPresented: $isShowDialog, titleVisibility: .visible, actions: {
            Button {
                isShowCamera.toggle()
            } label: {
            Text("Camera")
            }
            
            Button {
                isShowPhotoPicker.toggle()
            } label: {
                Text("Gallery")
            }
        })
        .fullScreenCover(isPresented: $isShowCamera) {
            CameraView(image: $image)
        }
        
        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
            EmptyView()
        }
        .photosPicker(isPresented: $isShowPhotoPicker, selection: $selectedItem)
        .onChange(of: image) { newItem in
            model.photo = newItem
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                // Обрабатываем выбранное фото
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        model.photo = uiImage
                    }
                }
            }
        }
    }
    
    private func accentColors(grayColor: Color) -> Color {
        switch state {
        case .normal: return grayColor
        case .error: return TTColors.red
        }
    }
}
