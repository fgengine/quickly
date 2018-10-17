//
//  Quickly
//

public class QImageSource : IQImageSource {

    public var image: UIImage?
    public var url: URL?
    public var size: CGSize
    public var scale: QImageSourceScale
    public var tintColor: UIColor?

    public init(
        _ image: UIImage,
        scale: QImageSourceScale = .originOrAspectFit,
        tintColor: UIColor? = nil
    ) {
        self.image = image
        self.size = image.size
        self.scale = scale
        self.tintColor = tintColor
    }

    public init(
        _ imageNamed: String,
        scale: QImageSourceScale = .originOrAspectFit,
        tintColor: UIColor? = nil
    ) {
        if let image = UIImage(named: imageNamed) {
            self.image = image
            self.size = image.size
        } else {
            self.size = CGSize.zero
        }
        self.scale = scale
        self.tintColor = tintColor
    }

    public init(
        _ url: URL,
        size: CGSize,
        scale: QImageSourceScale = .originOrAspectFit,
        tintColor: UIColor? = nil
    ) {
        self.url = url
        self.size = size
        self.scale = scale
        self.tintColor = tintColor
    }
    
    public init(
        _ source: IQImageSource,
        size: CGSize? = nil,
        scale: QImageSourceScale? = nil,
        tintColor: UIColor? = nil
    ) {
        self.image = source.image
        self.url = source.url
        self.size = size ?? source.size
        self.scale = scale ?? source.scale
        self.tintColor = tintColor ?? source.tintColor
    }

}
