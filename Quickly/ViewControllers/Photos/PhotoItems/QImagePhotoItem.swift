//
//  Quickly
//

public class QImagePhotoItem : IQPhotoItem {
    
    public var isNeedLoad: Bool {
        get { return false }
    }
    public var isLoading: Bool {
        get { return false }
    }
    public var size: CGSize {
        return CGSize(width: self._image.width, height: self._image.height)
    }
    public var image: UIImage? {
        get { return UIImage(cgImage: self._image) }
    }
    
    private var _observer: QObserver< IQPhotoItemObserver >
    private var _image: CGImage
    
    public static func photoItems(data: Data) -> [IQPhotoItem] {
        guard let provider = CGDataProvider(data: data as CFData) else { return [] }
        guard let imageSource = CGImageSourceCreateWithDataProvider(provider, nil) else { return [] }
        var photos: [QImagePhotoItem] = []
        for index in 0..<CGImageSourceGetCount(imageSource) {
            guard let image = CGImageSourceCreateImageAtIndex(imageSource, index, nil) else { continue }
            photos.append(QImagePhotoItem(image: image))
        }
        return photos
    }
    
    private init(image: CGImage) {
        self._observer = QObserver< IQPhotoItemObserver >()
        self._image = image
    }
    
    public func add(observer: IQPhotoItemObserver) {
        self._observer.add(observer, priority: 0)
    }
    
    public func remove(observer: IQPhotoItemObserver) {
        self._observer.remove(observer)
    }

    public func load() {
    }
    
    public func draw(context: CGContext, bounds: CGRect, scale: CGFloat) {
        context.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
        context.fill(bounds)
        context.saveGState()
        context.translateBy(x: 0, y: bounds.height)
        context.scaleBy(x: 1, y: -1)
        context.draw(self._image, in: bounds)
        context.restoreGState()
    }
    
}
