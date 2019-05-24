//
//  Quickly
//

public extension UIImage {

    func tintImage(_ color: UIColor) -> UIImage? {
        return modify { (context: CGContext, rect: CGRect) in
            if let cgImage = self.cgImage {
                context.setBlendMode(.normal)
                context.setFillColor(color.cgColor)
                context.fill(rect)
                context.setBlendMode(.destinationIn)
                context.draw(cgImage, in: rect)
            }
        }
    }
    
    func unrotate() -> UIImage? {
        guard self.imageOrientation != .up else {
            return self
        }
        let size = self.size
        let imageOrientation = self.imageOrientation
        var transform = CGAffineTransform.identity;
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -(CGFloat.pi / 2))
        default:
            break
        }
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        guard let cgImage = self.cgImage, let colorSpace = cgImage.colorSpace else {
            return nil
        }
        if let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue) {
            context.concatenate(transform)
            let rect: CGRect
            switch imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored: rect = CGRect(x: 0, y: 0, width: size.height, height: size.width)
            default: rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            }
            context.draw(cgImage, in: rect)
            if let image = context.makeImage() {
                return UIImage(cgImage: image, scale: self.scale, orientation: .up)
            }
        }
        return nil
    }
    
    func scaleTo(size: CGSize) -> UIImage? {
        guard let cgImage = self.cgImage, let colorSpace = cgImage.colorSpace else {
            return nil
        }
        let originalSize = self.size
        let originalScale = self.scale
        let aspectFitRect = originalSize.aspectFit(bounds: CGRect(origin: CGPoint.zero, size: size))
        let newSize = CGSize(
            width: floor(aspectFitRect.width),
            height: floor(aspectFitRect.height)
        )
        if let context = CGContext(data: nil, width: Int(newSize.width), height: Int(newSize.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue) {
            context.draw(cgImage, in: CGRect(origin: CGPoint.zero, size: newSize))
            if let image = context.makeImage() {
                return UIImage(cgImage: image, scale: originalScale, orientation: .up)
            }
        }
        return nil
    }

    func modify(_ draw: (CGContext, CGRect) -> ()) -> UIImage? {
        let size = self.size
        let scale = self.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            draw(context, CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }

}
