//
//  Quickly
//

public extension CIImage {
    
    func nonInterpolatedImage(withScale scale: CGPoint) -> UIImage? {
        guard let cgImage = CIContext(options: nil).createCGImage(self, from: self.extent) else {
            return nil
        }
        let size = CGSize(width: self.extent.size.width * scale.x, height: self.extent.size.height * scale.y)
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.interpolationQuality = .none
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(cgImage, in: context.boundingBoxOfClipPath)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
}
