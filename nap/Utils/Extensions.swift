import UIKit

// MARK: - UIImage Extension for Resizing
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func resized(to dimension: CGFloat) -> UIImage {
        let size = CGSize(width: dimension, height: dimension)
        return resized(to: size)
    }
} 