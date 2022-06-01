//
//  Quickly
//

public class QImageGrayscaleLoaderFilter : IQImageLoaderFilter {

    public var name: String {
        get { return "grayscale" }
    }
    
    public init() {
    }
    
    public func apply(_ image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        guard let filter = CIFilter(name: "CIPhotoEffectNoir") else {
            return nil
        }
        filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        if let output = filter.outputImage,
           let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
        }
        return nil
    }
    
}
