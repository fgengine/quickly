//
//  Quickly
//

public class QPdfPhotoItem : IQPhotoItem {
    
    public var isNeedLoad: Bool {
        get { return self.image == nil }
    }
    public var isLoading: Bool {
        get { return self._task != nil }
    }
    public var size: CGSize {
        let rect = self._page.getBoxRect(.mediaBox)
        switch self._page.rotationAngle {
        case 90, 270:
            return CGSize(width: rect.height, height: rect.width)
        default:
            return rect.size
        }
    }
    public private(set) var image: UIImage?
    
    private var _observer: QObserver< IQPhotoItemObserver >
    private var _page: CGPDFPage
    private var _task: DispatchWorkItem!
    
    public static func photoItems(data: Data) -> [IQPhotoItem] {
        guard let provider = CGDataProvider(data: data as CFData) else { return [] }
        guard let document = CGPDFDocument(provider) else { return [] }
        var photos: [QPdfPhotoItem] = []
        for pageIndex in 0..<document.numberOfPages {
            guard let page = document.page(at: pageIndex) else { continue }
            photos.append(QPdfPhotoItem(page: page))
        }
        return photos
    }
    
    private init(page: CGPDFPage) {
        self._observer = QObserver< IQPhotoItemObserver >()
        self._page = page
    }
    
    deinit {
        if let task = self._task {
            task.cancel()
        }
    }
    
    public func add(observer: IQPhotoItemObserver) {
        self._observer.add(observer, priority: 0)
    }
    
    public func remove(observer: IQPhotoItemObserver) {
        self._observer.remove(observer)
    }

    public func load() {
        if self.isLoading == false {
            self._observer.notify({ $0.willLoadPhotoItem(self) })
            self._task = DispatchWorkItem(block: { [weak self] in
                guard let self = self else { return }
                let image = QPdfPhotoItem._render(page: self._page)
                DispatchQueue.main.async(execute: { [weak self] in
                    guard let self = self else { return }
                    self.image = image
                    self._task = nil
                    self._observer.notify({ $0.didLoadPhotoItem(self) })
                })
            })
            DispatchQueue.global(qos: .background).sync(execute: self._task!)
        }
    }
    
    public func draw(context: CGContext, bounds: CGRect, scale: CGFloat) {
        QPdfPhotoItem._render(
            context: context,
            page: self._page,
            bounds: bounds,
            scale: CGPoint(x: scale, y: scale)
        )
    }
    
}

// MARK: Private

private extension QPdfPhotoItem {
    
    static func _render(page: CGPDFPage) -> UIImage? {
        let size: CGSize
        switch page.rotationAngle {
        case 90, 270: size = page.getBoxRect(.mediaBox).size.wrap()
        default: size = page.getBoxRect(.mediaBox).size
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        QPdfPhotoItem._render(
            context: context,
            page: page,
            bounds: CGRect(origin: CGPoint.zero, size: size),
            scale: nil
        )
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    static func _render(context: CGContext, page: CGPDFPage, bounds: CGRect, scale: CGPoint?) {
        let angle: CGFloat
        switch page.rotationAngle {
        case 90: angle = 270
        case 180: angle = 180
        case 270: angle = 90
        default: angle = 0
        }
        context.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
        context.fill(bounds)
        context.saveGState()
        switch angle {
        case 90, 270: context.translateBy(x: bounds.width, y: bounds.height)
        default: context.translateBy(x: 0, y: bounds.height)
        }
        context.scaleBy(x: 1, y: -1)
        context.rotate(by: angle.degreesToRadians)
        if let scale = scale {
            context.scaleBy(x: scale.x, y: scale.y)
        }
        context.drawPDFPage(page)
        context.restoreGState()
    }
    
}
