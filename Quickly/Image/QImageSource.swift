//
//  Quickly
//

import UIKit

public enum QImageSourceScale: Int {
    case stretch
    case aspectFit
    case aspectFill

    public func rect(bounds: CGRect, size: CGSize) -> CGRect {
        switch self {
        case .stretch: return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: size.width, height: size.height)
        case .aspectFit: return size.aspectFit(bounds: bounds)
        case .aspectFill: return size.aspectFill(bounds: bounds)
        }
    }

    public func toContentMode() -> UIViewContentMode {
        switch self {
        case .stretch: return UIViewContentMode.scaleToFill
        case .aspectFit: return UIViewContentMode.scaleAspectFit
        case .aspectFill: return UIViewContentMode.scaleAspectFill
        }
    }
}

public class QImageSource {

    public var size: CGSize
    public var image: UIImage?
    public var url: URL?
    public var renderingMode: UIImageRenderingMode = .automatic
    public var scale: QImageSourceScale = .aspectFit

    public init(_ image: UIImage) {
        self.size = image.size
        self.image = image
    }

    public init(_ imageNamed: String) {
        if let image: UIImage = UIImage(named: imageNamed) {
            self.size = image.size
            self.image = image
        } else {
            self.size = CGSize.zero
        }
    }

    public init(_ url: URL, size: CGSize) {
        self.size = size
        self.url = url
    }

    public func rect(bounds: CGRect) -> CGRect {
        return self.scale.rect(bounds: bounds, size: self.size)
    }

}
