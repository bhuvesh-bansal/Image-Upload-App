import SwiftUI
import PhotosUI
import UIKit // Add this import for UIImagePickerController

struct UploadView: View {
    @State private var selectedImage: Image?
    @State private var isShowingImagePicker = false
    @State private var isShowingPreview = false
    @State private var uiImage: UIImage?
    @State private var isShowingCamera = false // New state for camera

    var body: some View {
        VStack {
            Spacer()
            
            // Browser Gallery Section
            Button(action: {
                isShowingImagePicker = true
            }) {
                VStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.green)
                    Text("Browse Gallery")
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                        .foregroundColor(.green)
                )
                .padding(.horizontal)
            }
            .sheet(isPresented: $isShowingImagePicker) {
                PhotoPicker(selectedImage: $uiImage)
            }
            .onChange(of: uiImage) { newImage in
                if let newImage = newImage {
                    self.selectedImage = Image(uiImage: newImage)
                    isShowingPreview = true
                }
            }
            .fullScreenCover(isPresented: $isShowingPreview) {
                if let uiImage = uiImage {
                    PreviewView(isPresented: $isShowingPreview, selectedUIImage: uiImage)
                }
            }
            
            Text("OR")
                .padding(.vertical, 20)
                .foregroundColor(.gray)
            
            Button(action: {
                isShowingCamera = true
            }) {
                VStack {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.green)
                    Text("Open camera")
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                        .foregroundColor(.green)
                )
                .padding(.horizontal)
            }
            .sheet(isPresented: $isShowingCamera) {
                CameraPicker(selectedImage: $uiImage)
            }
            
            Spacer()
        }
        .navigationTitle("Upload")
        .navigationBarHidden(true)
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    UploadView()
} 
