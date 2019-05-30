//
//  Quickly
//

public class QImageRemoteSource {
    
    public var url: URL
    public var size: CGSize?
    public var loader: QImageLoader?
    public var filter: IQImageLoaderFilter?
    public var scale: QImageViewScale
    public var tintColor: UIColor?
    
    public init(
        url: URL,
        size: CGSize? = nil,
        loader: QImageLoader? = nil,
        filter: IQImageLoaderFilter? = nil,
        scale: QImageViewScale = .originOrAspectFit,
        tintColor: UIColor? = nil
    ) {
        self.url = url
        self.size = size
        self.loader = loader
        self.filter = filter
        self.scale = scale
        self.tintColor = tintColor
    }
    
    public init(
        source: QImageRemoteSource,
        size: CGSize? = nil,
        loader: QImageLoader? = nil,
        filter: IQImageLoaderFilter? = nil,
        scale: QImageViewScale? = nil,
        tintColor: UIColor? = nil
    ) {
        self.url = source.url
        self.size = size ?? source.size
        self.loader = loader ?? source.loader
        self.filter = filter ?? source.filter
        self.scale = scale ?? source.scale
        self.tintColor = tintColor ?? source.tintColor
    }
    
    func size(_ available: CGSize, image: UIImage) -> CGSize {
        guard let size = self.scale.size(available, size: self.size ?? image.size) else {
            return image.size.ceil()
        }
        return size
    }
    
}

extension QImageRemoteSource : Equatable {
    
    public static func == (lhs: QImageRemoteSource, rhs: QImageRemoteSource) -> Bool {
        return lhs.url == rhs.url && lhs.size == rhs.size && lhs.loader === rhs.loader && lhs.filter?.name == rhs.filter?.name && lhs.scale == rhs.scale && lhs.tintColor == rhs.tintColor
    }

}
