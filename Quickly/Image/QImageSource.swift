//
//  Quickly
//

import UIKit

public enum QImageSourceScale: Int {
    case origin
    case stretch
    case aspectFit
    case aspectFill
    case originOrAspectFit
    case originOrAspectFill
    
    public func rect(bounds: CGRect, size: CGSize) -> CGRect? {
        guard bounds.width > CGFloat.leastNonzeroMagnitude && bounds.height > CGFloat.leastNonzeroMagnitude else {
            return nil
        }
        guard size.width > CGFloat.leastNonzeroMagnitude && size.height > CGFloat.leastNonzeroMagnitude else {
            return nil
        }
        switch self {
        case .origin: return CGRect(origin: bounds.origin, size: size)
        case .stretch: return CGRect(origin: bounds.origin, size: size)
        case .aspectFit: return size.aspectFit(bounds: bounds)
        case .aspectFill: return size.aspectFill(bounds: bounds)
        case .originOrAspectFit: return (bounds.width > size.width) && (bounds.height > size.height) ?
            CGRect(x: bounds.midX - (size.width / 2), y: bounds.midY - (size.height / 2), width: size.width, height: size.height) :
            size.aspectFit(bounds: bounds)
        case .originOrAspectFill: return (bounds.width > size.width) && (bounds.height > size.height) ?
            CGRect(x: bounds.midX - (size.width / 2), y: bounds.midY - (size.height / 2), width: size.width, height: size.height) :
            size.aspectFill(bounds: bounds)
        }
    }
    
    public func size(available: CGSize, size: CGSize) -> CGSize? {
        let bounds: CGRect = CGRect(x: 0, y: 0, width: available.width, height: available.height)
        guard let rect: CGRect = self.rect(bounds: bounds, size: size) else {
            return nil
        }
        return rect.integral.size
    }
}

public class QImageSource {

    public var image: UIImage?
    public var size: CGSize
    public var url: URL?
    public var renderingMode: UIImageRenderingMode = .automatic
    public var scale: QImageSourceScale = .aspectFit

    public init(_ image: UIImage, scale: QImageSourceScale = .aspectFit) {
        self.size = image.size
        self.image = image
        self.scale = scale
    }

    public init(_ imageNamed: String, scale: QImageSourceScale = .aspectFit) {
        if let image: UIImage = UIImage(named: imageNamed) {
            self.size = image.size
            self.image = image
            self.scale = scale
        } else {
            self.size = CGSize.zero
        }
    }

    public init(_ url: URL, size: CGSize, scale: QImageSourceScale = .aspectFit) {
        self.size = size
        self.url = url
        self.scale = scale
    }

    public func rect(bounds: CGRect, image: UIImage? = nil) -> CGRect {
        var size: CGSize
        if let image: UIImage = image {
            size = image.size
        } else {
            size = self.size
        }
        guard let scaleRect: CGRect = self.scale.rect(bounds: bounds, size: size) else {
            return bounds
        }
        return scaleRect
    }

    public func size(available: CGSize, image: UIImage? = nil) -> CGSize {
        var size: CGSize
        if let image: UIImage = image {
            size = image.size
        } else {
            size = self.size
        }
        guard let scaleSize: CGSize = self.scale.size(available: available, size: size) else {
            return self.size
        }
        return scaleSize
    }

}
