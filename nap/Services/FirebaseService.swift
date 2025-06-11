import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

protocol FirebaseServiceProtocol {
    func uploadImage(_ image: UIImage, referenceName: String) async throws
    func fetchImages() async throws -> [GalleryImage]
}

class FirebaseService: FirebaseServiceProtocol {
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    func uploadImage(_ image: UIImage, referenceName: String) async throws {
        print("Starting image upload process...")
        
        // Resize image
        let resizedImage = image.resized(to: 1024)
        
        // Convert to data
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.7) else {
            print("Failed to convert image to data")
            throw AppError.imageConversionFailed
        }
        
        // Upload to Firebase Storage
        let imageFileName = "\(UUID().uuidString).jpg"
        let imageRef = storage.reference().child("images/\(imageFileName)")
        
        print("Uploading image to Firebase Storage...")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        _ = try await imageRef.putDataAsync(imageData, metadata: metadata)
        let downloadURL = try await imageRef.downloadURL()
        print("Image uploaded successfully. URL: \(downloadURL.absoluteString)")
        
        // Save to Firestore
        print("Saving image metadata to Firestore...")
        try await db.collection("images").addDocument(data: [
            "url": downloadURL.absoluteString,
            "referenceName": referenceName,
            "timestamp": FieldValue.serverTimestamp()
        ])
        print("Image metadata saved successfully")
    }
    
    func fetchImages() async throws -> [GalleryImage] {
        print("Starting to fetch images from Firestore...")
        
        // Get all documents without any limit
        let snapshot = try await db.collection("images")
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        print("Found \(snapshot.documents.count) total documents in Firestore")
        
        // Log all document IDs for debugging
        print("Document IDs found:")
        snapshot.documents.forEach { doc in
            print("- \(doc.documentID)")
        }
        
        let images = snapshot.documents.compactMap { document -> GalleryImage? in
            let data = document.data()
            print("\nProcessing document \(document.documentID):")
            print("Document data: \(data)")
            
            guard let url = data["url"] as? String else {
                print("❌ Missing URL for document \(document.documentID)")
                return nil
            }
            
            guard let name = data["referenceName"] as? String else {
                print("❌ Missing referenceName for document \(document.documentID)")
                return nil
            }
            
            print("✅ Successfully parsed image: \(name)")
            print("   URL: \(url)")
            return GalleryImage(id: document.documentID, url: url, name: name)
        }
        
        print("\nFinal results:")
        print("Total documents found: \(snapshot.documents.count)")
        print("Successfully parsed images: \(images.count)")
        print("Failed to parse: \(snapshot.documents.count - images.count)")
        
        return images
    }
} 