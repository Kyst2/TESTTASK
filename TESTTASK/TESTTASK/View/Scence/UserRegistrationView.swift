import SwiftUI
import PhotosUI

struct UserRegistrationView: View {
    @ObservedObject var model = RegistrationViewModel()
    
    @State private var showingImagePicker = false
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var image: UIImage?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                PersonalData()
                
                PositionalsRadioGroup()
                
                SelectPhoto(model: model)
            }
            .padding(.top, 32)
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    func PersonalData() -> some View {
        RegistrationTextField(label: "Your name",
                              text: $model.name,
                              errorText: $model.nameError,
                              supportingText: nil)
        
        RegistrationTextField(label: "Email",
                              text: $model.email,
                              errorText: $model.emailError,
                              supportingText: nil)
        
        RegistrationTextField(label: "Phone",
                              text: $model.phone,
                              errorText: $model.phoneError,
                              supportingText: "+38(XXX) XXX - XX - XX")
    }
    
    @ViewBuilder
    func PositionalsRadioGroup() -> some View {
        Text("Select your position")
            .font(.nunoRegular(size: 18))
            .foregroundStyle(.black.opacity(0.87))
        
        if !model.positions.isEmpty {
            CustomRadioGroupView(model: model)
                .padding(.top,-12)
        } else if model.isLoading {
            ProgressView()
                .padding()
                .frame(maxWidth: .infinity)
        }
    }
}

struct SelectPhoto: View {
    @ObservedObject var model: RegistrationViewModel
    @State  var image: UIImage?
    @State var selectedItem: PhotosPickerItem?
    
    @State private var isShowDialog: Bool = false
    @State private var isShowPhotoPicker = false
    @State private var isShowCamera = false
    
    var state: FieldState = .normal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let photo = model.photo {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20 , height: 20)
                } else {
                    Text("Upload your photo")
                        .foregroundColor(accentColors)
                        .font(.nunoRegular(size: 16))
                }
                
                
                Button {
                    isShowDialog = true
                } label: {
                    Text("Upload")
                        .foregroundStyle(.blue)
                }
            }
            .padding(16)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(hex: 0xd0cfcf), lineWidth: 1)
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
    }
    
    private var accentColors: Color {
        switch state {
        case .normal: return Color.black.opacity(0.48)
        case .error: return TTColors.red
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

