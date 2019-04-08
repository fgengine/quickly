//
//  Quickly
//

public class QImageRemoteSource {
    
    public var url: URL
    public var loader: QImageLoader?
    public var filter: IQImageLoaderFilter?
    public var scale: QImageViewScale
    public var tintColor: UIColor?
    
    public init(
        url: URL,
        loader: QImageLoader? = nil,
        filter: IQImageLoaderFilter? = nil,
        scale: QImageViewScale = .originOrAspectFit,
        tintColor: UIColor? = nil
    ) {
        self.url = url
        self.loader = loader
        self.filter = filter
        self.scale = scale
        self.tintColor = tintColor
    }
    
    public init(
        source: QImageRemoteSource,
        loader: QImageLoader? = nil,
        filter: IQImageLoaderFilter? = nil,
        scale: QImageViewScale? = nil,
        tintColor: UIColor? = nil
    ) {
        self.url = source.url
        self.loader = loader ?? source.loader
        self.filter = filter ?? source.filter
        self.scale = scale ?? source.scale
        self.tintColor = tintColor ?? source.tintColor
    }
    
    func size(_ available: CGSize, image: UIImage) -> CGSize {
        guard let size = self.scale.size(available, size: image.size) else {
            return image.size.ceil()
        }
        return size
    }
    
}
