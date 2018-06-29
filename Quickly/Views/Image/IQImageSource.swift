//
//  Quickly
//

public enum QImageSourceScale : Int {
    case origin
    case stretch
    case aspectFit
    case aspectFill
    case originOrAspectFit
    case originOrAspectFill

    public func rect(_ bounds: CGRect, size: CGSize) -> CGRect? {
        guard bounds.width > CGFloat.leastNonzeroMagnitude && bounds.height > CGFloat.leastNonzeroMagnitude else { return nil }
        guard size.width > CGFloat.leastNonzeroMagnitude && size.height > CGFloat.leastNonzeroMagnitude else { return nil }
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

    public func size(_ available: CGSize, size: CGSize) -> CGSize? {
        let bounds = CGRect(x: 0, y: 0, width: available.width, height: available.height)
        guard let rect = self.rect(bounds, size: size) else { return nil }
        return rect.integral.size
    }
}

public protocol IQImageSource : class {

    var image: UIImage? { get }
    var size: CGSize { get }
    var url: URL? { get }
    var renderingMode: UIImageRenderingMode { get }
    var scale: QImageSourceScale { get }
    var tintColor: UIColor? { get }

    func rect(_ bounds: CGRect, image: UIImage?) -> CGRect
    func size(_ available: CGSize, image: UIImage?) -> CGSize

}

public extension IQImageSource {

    public func rect(_ bounds: CGRect, image: UIImage? = nil) -> CGRect {
        var size: CGSize
        if let image = image {
            size = image.size
        } else {
            size = self.size
        }
        guard let scaleRect = self.scale.rect(bounds, size: size) else { return bounds }
        return scaleRect
    }

    public func size(_ available: CGSize, image: UIImage? = nil) -> CGSize {
        var size: CGSize
        if let image = image {
            size = image.size
        } else {
            size = self.size
        }
        guard let scaleSize = self.scale.size(available, size: size) else { return self.size }
        return scaleSize
    }

}
