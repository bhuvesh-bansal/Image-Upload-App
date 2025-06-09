import SwiftUI
import Kingfisher

struct ImageDetailView: View {
    let image: GalleryImage

    var body: some View {
        VStack {
            KFImage(URL(string: image.url))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()

            Text(image.name)
                .font(.title)
                .padding()

            Spacer()
        }
        .navigationTitle(image.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ImageDetailView(image: GalleryImage(url: "https://via.placeholder.com/400", name: "Sample Image"))
} 