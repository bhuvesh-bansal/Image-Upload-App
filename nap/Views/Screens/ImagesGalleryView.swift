import SwiftUI
import Kingfisher

struct ImagesGalleryView: View {
    @StateObject private var viewModel = GalleryViewModel()
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: AppConfig.Image.gridColumns)
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView("Loading images...")
                        .padding()
                } else if let error = viewModel.error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.images.isEmpty {
                    Text("No images uploaded yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    LazyVGrid(columns: columns, spacing: AppConfig.UI.spacing) {
                        ForEach(viewModel.images) { item in
                            NavigationLink(destination: ImageDetailView(image: item)) {
                                VStack {
                                    KFImage(URL(string: item.url))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: AppConfig.Image.thumbnailSize, height: AppConfig.Image.thumbnailSize)
                                        .cornerRadius(AppConfig.UI.cornerRadius)
                                        .clipped()
                                    Text(item.name)
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Images")
            .task {
                await viewModel.fetchImages()
            }
        }
    }
}

#Preview {
    ImagesGalleryView()
} 
