import SwiftUI
import UIKit

// Remove incorrect imports
// @_exported import struct nap.Models.ImageUploadViewModel
// @_exported import struct nap.Utils.AppConfig

struct PreviewView: View {
    @Binding var isPresented: Bool
    var selectedUIImage: UIImage?
    @StateObject private var viewModel = ImageUploadViewModel()
    @State private var referenceName: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                }
                .padding([.top, .trailing])
            }
            
            if let uiImage = selectedUIImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            } else {
                Text("No Image Selected")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            }
            
            TextField("Reference Name", text: $referenceName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                if referenceName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    alertMessage = "You need to provide a reference name before uploading."
                    showingAlert = true
                } else {
                    uploadImage()
                }
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.trailing, 5)
                    }
                    Text(viewModel.isLoading ? "Uploading..." : "Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(AppConfig.UI.cornerRadius)
            }
            .padding()
            .disabled(viewModel.isLoading)

            if let error = viewModel.error {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .alert("Missing Information", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    private func uploadImage() {
        guard let uiImage = selectedUIImage else { return }
        
        Task {
            await viewModel.uploadImage(uiImage, referenceName: referenceName)
            if viewModel.error == nil {
                isPresented = false
            }
        }
    }
}

#Preview {
    PreviewView(isPresented: .constant(true), selectedUIImage: UIImage(systemName: "photo"))
} 