import SwiftUI
import Kingfisher

struct ImageDetailView: View {
    let image: GalleryImage
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    KFImage(URL(string: image.url))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(AppConfig.UI.cornerRadius)
                    
                    Text(image.name)
                        .font(.title2)
                        .fontWeight(.medium)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

#Preview {
    ImageDetailView(image: GalleryImage(id: "preview", url: "https://via.placeholder.com/400", name: "Sample Image"))
} 
