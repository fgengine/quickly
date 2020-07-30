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
    
    func unrotate(maxResolution: CGFloat) -> UIImage {
        guard let imgRef = self.cgImage else {
            return self
        }
        let width = CGFloat(imgRef.width);
        let height = CGFloat(imgRef.height);
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        var scaleRatio : CGFloat = 1
        if width > maxResolution || height > maxResolution {
            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }
        let orientation = self.imageOrientation
        var transform = CGAffineTransform.identity
        let imageSize = CGSize(width: CGFloat(imgRef.width), height: CGFloat(imgRef.height))
        switch imageOrientation {
        case .up:
            transform = CGAffineTransform.identity
        case .upMirrored:
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        case .down:
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
            transform = transform.rotated(by: .pi)
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height)
            transform = transform.scaledBy(x: 1.0, y: -1.0)
        case .left:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width)
            transform = transform.rotated(by: 3.0 * .pi / 2.0)
        case .leftMirrored:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            transform = transform.rotated(by: 3.0 * .pi / 2.0)
        case .right:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0)
            transform = transform.rotated(by: .pi / 2.0)
        case .rightMirrored:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transform = transform.rotated(by: .pi / 2.0)
        @unknown default:
            fatalError()
        }
        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }
        if orientation == .right || orientation == .left {
            context.scaleBy(x: -scaleRatio, y: scaleRatio)
            context.translateBy(x: -height, y: 0)
        } else {
            context.scaleBy(x: scaleRatio, y: -scaleRatio)
            context.translateBy(x: 0, y: -height)
        }
        context.concatenate(transform)
        context.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let imageCopy = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }
        UIGraphicsEndImageContext()
        return imageCopy
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
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
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
