//
//  Quickly
//

import UIKit

public enum QImageSourceScale: Int {
    case stretch
    case aspectFit
    case aspectFill

    public func toContentMode() -> UIViewContentMode {
        switch self {
        case .stretch: return UIViewContentMode.scaleToFill
        case .aspectFit: return UIViewContentMode.scaleAspectFit
        case .aspectFill: return UIViewContentMode.scaleAspectFill
        }
    }

    public func rect(bounds: CGRect, size: CGSize) -> CGRect {
        let validBounds: Bool = bounds.width > CGFloat.leastNonzeroMagnitude && bounds.height > CGFloat.leastNonzeroMagnitude
        let validSize: Bool = size.width > CGFloat.leastNonzeroMagnitude && size.height > CGFloat.leastNonzeroMagnitude
        if validBounds == true && validSize == true {
            switch self {
            case .stretch: return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: size.width, height: size.height)
            case .aspectFit: return size.aspectFit(bounds: bounds)
            case .aspectFill: return size.aspectFill(bounds: bounds)
            }
        }
        return bounds
    }

    public func size(available: CGSize, size: CGSize) -> CGSize {
        let validAvailable: Bool = available.width > CGFloat.leastNonzeroMagnitude && available.height > CGFloat.leastNonzeroMagnitude
        let validSize: Bool = size.width > CGFloat.leastNonzeroMagnitude && size.height > CGFloat.leastNonzeroMagnitude
        if validAvailable == true && validSize == true {
            switch self {
            case .stretch: return available
            case .aspectFit: return size.aspectFit(bounds: CGRect(origin: CGPoint.zero, size: available)).size
            case .aspectFill: return available
            }
        }
        return size
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

    public func size(available: CGSize) -> CGSize {
        return self.scale.size(available: available, size: self.size)
    }

}
