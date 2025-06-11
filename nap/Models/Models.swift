import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import UIKit

// MARK: - Models
struct GalleryImage: Identifiable {
    let id: String
    let url: String
    let name: String
}

// MARK: - ViewModels
@MainActor
class ImageUploadViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var error: Error?
    private let firebaseService: FirebaseServiceProtocol
    
    init(firebaseService: FirebaseServiceProtocol = FirebaseService()) {
        self.firebaseService = firebaseService
    }
    
    func uploadImage(_ image: UIImage, referenceName: String) async {
        isLoading = true
        error = nil
        
        do {
            try await firebaseService.uploadImage(image, referenceName: referenceName)
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
}

@MainActor
class GalleryViewModel: ObservableObject {
    @Published var images: [GalleryImage] = []
    @Published var isLoading = false
    @Published var error: Error?
    private let firebaseService: FirebaseServiceProtocol
    
    init(firebaseService: FirebaseServiceProtocol = FirebaseService()) {
        self.firebaseService = firebaseService
    }
    
    func fetchImages() async {
        print("\n=== Starting GalleryViewModel.fetchImages() ===")
        isLoading = true
        error = nil
        
        do {
            print("Calling FirebaseService to fetch images...")
            let fetchedImages = try await firebaseService.fetchImages()
            print("Received \(fetchedImages.count) images from FirebaseService")
            
            // Log each image for debugging
            fetchedImages.forEach { image in
                print("Image: \(image.name)")
                print("  ID: \(image.id)")
                print("  URL: \(image.url)")
            }
            
            // Update the published property
            self.images = fetchedImages
            print("Updated images array with \(self.images.count) items")
            
            isLoading = false
        } catch {
            print("❌ Error fetching images: \(error.localizedDescription)")
            self.error = error
            isLoading = false
        }
        print("=== Finished GalleryViewModel.fetchImages() ===\n")
    }
} 