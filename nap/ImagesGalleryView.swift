import SwiftUI
import FirebaseFirestore
import Kingfisher

struct GalleryImage: Identifiable {
    let id = UUID()
    let url: String
    let name: String
}

struct ImagesGalleryView: View {
    @State private var images: [GalleryImage] = []
    @State private var isLoading = false
    @State private var fetchError: String?

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            ScrollView {
                if isLoading {
                    ProgressView("Loading images...")
                        .padding()
                } else if let fetchError = fetchError {
                    Text("Error: \(fetchError)")
                        .foregroundColor(.red)
                        .padding()
                } else if images.isEmpty {
                    Text("No images uploaded yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(images) { item in
                            VStack {
                                KFImage(URL(string: item.url))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(10)
                                    .clipped()
                                Text(item.name)
                                    .font(.caption)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Images")
            .onAppear(perform: fetchImages)
        }
    }

    private func fetchImages() {
        isLoading = true
        fetchError = nil
        let db = Firestore.firestore()
        db.collection("uploadedImages").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            isLoading = false
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                self.fetchError = "Failed to load images."
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found.")
                return
            }

            self.images = documents.compactMap { doc -> GalleryImage? in
                let data = doc.data()
                guard let imageURL = data["imageURL"] as? String,
                      let referenceName = data["referenceName"] as? String else {
                    return nil
                }
                return GalleryImage(url: imageURL, name: referenceName)
            }
        }
    }
}

#Preview {
    ImagesGalleryView()
} 
