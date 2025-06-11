import Foundation

enum AppConfig {
    enum Image {
        static let maxDimension: CGFloat = 1024
        static let compressionQuality: CGFloat = 0.8
        static let thumbnailSize: CGFloat = 150
        static let gridColumns = 2
    }
    
    enum Firebase {
        static let imagesCollection = "uploadedImages"
        static let imagesStoragePath = "images"
    }
    
    enum UI {
        static let cornerRadius: CGFloat = 10
        static let padding: CGFloat = 20
        static let spacing: CGFloat = 20
    }
} 