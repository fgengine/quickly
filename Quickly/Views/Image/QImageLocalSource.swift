//
//  Quickly
//

public class QImageLocalSource {

    public var image: UIImage
    public var size: CGSize
    public var scale: QImageViewScale
    public var tintColor: UIColor?
    
    public init(
        image: UIImage,
        size: CGSize? = nil,
        scale: QImageViewScale = .originOrAspectFit,
        tintColor: UIColor? = nil
    ) {
        self.image = image
        self.size = size ?? image.size
        self.scale = scale
        self.tintColor = tintColor
    }
    
    public convenience init(
        image: String,
        size: CGSize? = nil,
        scale: QImageViewScale = .originOrAspectFit,
        tintColor: UIColor? = nil
    ) {
        self.init(
            image: UIImage(named: image)!,
            size: size,
            scale: scale,
            tintColor: tintColor
        )
    }
    
    public init(
        source: QImageLocalSource,
        size: CGSize? = nil,
        scale: QImageViewScale? = nil,
        tintColor: UIColor? = nil
    ) {
        self.image = source.image
        self.size = size ?? source.size
        self.scale = scale ?? source.scale
        self.tintColor = tintColor ?? source.tintColor
    }
    
    func size(_ available: CGSize) -> CGSize {
        guard let size = self.scale.size(available, size: self.size) else {
            return self.image.size.ceil()
        }
        return size
    }

}
