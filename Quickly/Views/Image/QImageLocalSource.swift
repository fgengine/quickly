//
//  Quickly
//

public class QImageLocalSource {

    public var image: UIImage
    public var scale: QImageViewScale
    public var tintColor: UIColor?
    
    public init(
        image: UIImage,
        scale: QImageViewScale = .originOrAspectFit,
        tintColor: UIColor? = nil
    ) {
        self.image = image
        self.scale = scale
        self.tintColor = tintColor
    }
    
    public init(
        image: String,
        scale: QImageViewScale = .originOrAspectFit,
        tintColor: UIColor? = nil
    ) {
        self.image = UIImage(named: image)!
        self.scale = scale
        self.tintColor = tintColor
    }
    
    public init(
        source: QImageLocalSource,
        scale: QImageViewScale? = nil,
        tintColor: UIColor? = nil
    ) {
        self.image = source.image
        self.scale = scale ?? source.scale
        self.tintColor = tintColor ?? source.tintColor
    }
    
    func size(_ available: CGSize) -> CGSize {
        guard let size = self.scale.size(available, size: self.image.size) else {
            return self.image.size.ceil()
        }
        return size
    }

}
