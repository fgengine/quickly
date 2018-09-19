//
//  Quickly
//

public class QImageSource : IQImageSource {

    public var image: UIImage?
    public var size: CGSize
    public var url: URL?
    public var renderingMode: UIImage.RenderingMode
    public var scale: QImageSourceScale
    public var tintColor: UIColor?

    public init(
        _ image: UIImage,
        renderingMode: UIImage.RenderingMode = .automatic,
        scale: QImageSourceScale = .originOrAspectFit,
        tintColor: UIColor? = nil
    ) {
        self.image = image
        self.size = image.size
        self.renderingMode = renderingMode
        self.scale = scale
        self.tintColor = tintColor
    }

    public init(
        _ imageNamed: String,
        renderingMode: UIImage.RenderingMode = .automatic,
        scale: QImageSourceScale = .originOrAspectFit,
        tintColor: UIColor? = nil
    ) {
        if let image = UIImage(named: imageNamed) {
            self.image = image
            self.size = image.size
        } else {
            self.size = CGSize.zero
        }
        self.renderingMode = renderingMode
        self.scale = scale
        self.tintColor = tintColor
    }

    public init(
        _ url: URL,
        size: CGSize,
        renderingMode: UIImage.RenderingMode = .automatic,
        scale: QImageSourceScale = .originOrAspectFit,
        tintColor: UIColor? = nil
    ) {
        self.size = size
        self.url = url
        self.renderingMode = renderingMode
        self.scale = scale
        self.tintColor = tintColor
    }

}
