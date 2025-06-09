import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseStorage

struct PreviewView: View {
    @Binding var isPresented: Bool
    var selectedUIImage: UIImage?
    @State private var referenceName: String = ""
    @State private var isLoading = false
    @State private var uploadError: String?
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
                    uploadImageAndMetadata()
                }
            }) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.trailing, 5)
                    }
                    Text(isLoading ? "Uploading..." : "Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(10)
            }
            .padding()
            .disabled(isLoading)

            if let uploadError = uploadError {
                Text(uploadError)
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

    private func uploadImageAndMetadata() {
        print("uploadImageAndMetadata called. Current isLoading: \(isLoading)")
        guard let uiImage = selectedUIImage,
              let imageData = uiImage.jpegData(compressionQuality: 0.8) else {
            uploadError = "No image selected or unable to convert to data."
            return
        }

        isLoading = true
        print("isLoading set to true.")
        uploadError = nil

        let storageRef = Storage.storage().reference()
        let imageFileName = UUID().uuidString + ".jpg"
        let imageRef = storageRef.child("images/\(imageFileName)")

        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.uploadError = "Error uploading image: \(error.localizedDescription)"
                    self.isLoading = false
                }
                return
            }

            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.uploadError = "Error getting download URL: \(error.localizedDescription)"
                        self.isLoading = false
                    }
                    return
                }

                guard let downloadURL = url else {
                    print("Download URL is nil, but no error reported.")
                    DispatchQueue.main.async {
                        self.uploadError = "Failed to get image download URL."
                        self.isLoading = false
                    }
                    return
                }

                let db = Firestore.firestore()
                db.collection("uploadedImages").addDocument(data: [
                    "referenceName": self.referenceName,
                    "imageURL": downloadURL.absoluteString,
                    "timestamp": FieldValue.serverTimestamp()
                ]) { error in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        if let error = error {
                            print("Error saving document: \(error.localizedDescription)")
                            self.uploadError = "Error saving image data: \(error.localizedDescription)"
                        } else {
                            print("Image and metadata saved successfully!")
                            self.isPresented = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PreviewView(isPresented: .constant(true), selectedUIImage: UIImage(systemName: "photo"))
} 