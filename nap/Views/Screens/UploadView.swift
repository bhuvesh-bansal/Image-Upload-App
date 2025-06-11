import SwiftUI
import PhotosUI
import UIKit

// Remove incorrect imports
// @_exported import struct nap.Models.ImageUploadViewModel
// @_exported import struct nap.Utils.AppConfig

struct UploadView: View {
    @StateObject private var viewModel = ImageUploadViewModel()
    @State private var selectedImage: Image?
    @State private var isShowingImagePicker = false
    @State private var isShowingPreview = false
    @State private var uiImage: UIImage?
    @State private var isShowingCamera = false
    @State private var referenceName: String = ""

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
                    RoundedRectangle(cornerRadius: AppConfig.UI.cornerRadius)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                        .foregroundColor(.green)
                )
                .padding(.horizontal)
            }
            .sheet(isPresented: $isShowingImagePicker) {
                PhotoPicker(selectedImage: $uiImage)
            }
            .onChange(of: uiImage) { oldValue, newValue in
                if let newImage = newValue {
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
                .padding(.vertical, AppConfig.UI.padding)
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
                    RoundedRectangle(cornerRadius: AppConfig.UI.cornerRadius)
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

#Preview {
    UploadView()
} 