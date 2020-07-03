//
//  Quickly
//

public extension UIImage {
    
    convenience init?(size: CGSize, scale: CGFloat, color: UIColor) {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
            if let image = context.makeImage() {
                self.init(cgImage: image)
            }
        }
        return nil
    }

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
        guard let cgImage = self.cgImage else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        if let context = UIGraphicsGetCurrentContext() {
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
        guard let cgImage = self.cgImage else {
            return nil
        }
        let originalSize = self.size
        let originalScale = self.scale
        let aspectFitRect = CGRect(origin: CGPoint.zero, size: size).aspectFit(size: originalSize)
        let size = CGSize(
            width: Int(floor(aspectFitRect.width)),
            height: Int(floor(aspectFitRect.height))
        )
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        if let context = UIGraphicsGetCurrentContext() {
            context.draw(cgImage, in: CGRect(origin: .zero, size: size))
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
    
    func compare(expected: UIImage, tolerance: CGFloat) -> Bool {
        guard let expected = expected.cgImage, let observed = self.cgImage else {
            return false
        }
        guard let expectedColorSpace = expected.colorSpace, let observedColorSpace = observed.colorSpace else {
            return false
        }
        if expected.width != observed.width || expected.height != observed.height {
            return false
        }
        let imageSize = CGSize(width: expected.width, height: expected.height)
        let numberOfPixels = Int(imageSize.width * imageSize.height)
        let bytesPerRow = min(expected.bytesPerRow, observed.bytesPerRow)
        assert(MemoryLayout< UInt32 >.stride == bytesPerRow / Int(imageSize.width))
        let expectedPixels = UnsafeMutablePointer<UInt32>.allocate(capacity: numberOfPixels)
        let observedPixels = UnsafeMutablePointer<UInt32>.allocate(capacity: numberOfPixels)
        let expectedPixelsRaw = UnsafeMutableRawPointer(expectedPixels)
        let observedPixelsRaw = UnsafeMutableRawPointer(observedPixels)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let expectedContext = CGContext(data: expectedPixelsRaw, width: Int(imageSize.width), height: Int(imageSize.height), bitsPerComponent: expected.bitsPerComponent, bytesPerRow: bytesPerRow, space: expectedColorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            expectedPixels.deallocate()
            observedPixels.deallocate()
            return false
        }
        guard let observedContext = CGContext(data: observedPixelsRaw, width: Int(imageSize.width), height: Int(imageSize.height), bitsPerComponent: observed.bitsPerComponent, bytesPerRow: bytesPerRow, space: observedColorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            expectedPixels.deallocate()
            observedPixels.deallocate()
            return false
        }
        expectedContext.draw(expected, in: CGRect(origin: .zero, size: imageSize))
        observedContext.draw(observed, in: CGRect(origin: .zero, size: imageSize))
        let expectedBuffer = UnsafeBufferPointer(start: expectedPixels, count: numberOfPixels)
        let observedBuffer = UnsafeBufferPointer(start: observedPixels, count: numberOfPixels)
        var isEqual = true
        if tolerance == 0 {
            isEqual = expectedBuffer.elementsEqual(observedBuffer)
        } else {
            var numDiffPixels = 0
            for pixel in 0 ..< numberOfPixels where expectedBuffer[pixel] != observedBuffer[pixel] {
                numDiffPixels += 1
                let percentage = 100 * CGFloat(numDiffPixels) / CGFloat(numberOfPixels)
                if percentage > tolerance {
                    isEqual = false
                    break
                }
            }
        }
        expectedPixels.deallocate()
        observedPixels.deallocate()
        return isEqual
    }

}
