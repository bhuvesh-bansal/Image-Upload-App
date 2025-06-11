import Foundation

enum AppError: LocalizedError {
    case imageResizeFailed
    case imageConversionFailed
    case uploadFailed(Error)
    case downloadURLFailed
    case databaseError(Error)
    case fetchFailed(Error)
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .imageResizeFailed:
            return "Failed to resize the image. Please try again with a different image."
        case .imageConversionFailed:
            return "Failed to process the image. Please try again with a different image."
        case .uploadFailed(let error):
            return "Failed to upload image: \(error.localizedDescription)"
        case .downloadURLFailed:
            return "Failed to get image URL. Please try uploading again."
        case .databaseError(let error):
            return "Database error: \(error.localizedDescription)"
        case .fetchFailed(let error):
            return "Failed to fetch images: \(error.localizedDescription)"
        case .invalidData:
            return "Invalid data received. Please try again."
        }
    }
} 