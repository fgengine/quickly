//
//  Quickly
//

open class QImageViewStyleSheet : QDisplayViewStyleSheet {

    public var source: IQImageSource
    public var verticalAlignment: QViewVerticalAlignment
    public var horizontalAlignment: QViewHorizontalAlignment
    public var filter: IQImageLoaderFilter?
    public var loader: QImageLoader?

    public init(
        source: IQImageSource,
        verticalAlignment: QViewVerticalAlignment = .center,
        horizontalAlignment: QViewHorizontalAlignment = .center,
        filter: IQImageLoaderFilter? = nil,
        loader: QImageLoader? = nil,
        backgroundColor: UIColor? = nil
    ) {
        self.source = source
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.filter = filter
        self.loader = loader

        super.init(backgroundColor: backgroundColor)
    }

    public init(_ styleSheet: QImageViewStyleSheet) {
        self.source = styleSheet.source
        self.verticalAlignment = styleSheet.verticalAlignment
        self.horizontalAlignment = styleSheet.horizontalAlignment

        super.init(styleSheet)
    }

}

open class QImageView : QDisplayView {

    public private(set) var isDownloading: Bool = false
    public var verticalAlignment: QViewVerticalAlignment = .center {
        didSet { self.setNeedsDisplay() }
    }
    public var horizontalAlignment: QViewHorizontalAlignment = .center {
        didSet { self.setNeedsDisplay() }
    }
    public var source: IQImageSource? {
        willSet { self.stopDownloading() }
        didSet {
            if let source = self.source {
                if let image = source.image {
                    if source.tintColor != nil {
                        self.image = image.withRenderingMode(.alwaysTemplate)
                    } else {
                        self.image = image.withRenderingMode(.alwaysOriginal)
                    }
                } else {
                    self.image = nil
                }
                self.tintColor = source.tintColor
                self.startDownloading()
            } else {
                self.image = nil
                self.tintColor = nil
            }
        }
    }
    public var filter: IQImageLoaderFilter? {
        willSet { self.stopDownloading() }
    }
    public var loader: QImageLoader? {
        willSet { self.stopDownloading() }
    }
    public private(set) var image: UIImage? {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsDisplay()
        }
    }
    
    public required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    public convenience init(frame: CGRect, styleSheet: QImageViewStyleSheet) {
        self.init(frame: frame)
        self.apply(styleSheet)
    }
    
    open override var frame: CGRect {
        set(value) {
            if(super.frame != value) {
                super.frame = value
                self.invalidateIntrinsicContentSize()
                self.setNeedsDisplay()
            }
        }
        get { return super.frame }
    }
    open override var bounds: CGRect {
        set(value) {
            if(super.bounds != value) {
                super.bounds = value
                self.invalidateIntrinsicContentSize()
                self.setNeedsDisplay()
            }
        }
        get { return super.bounds }
    }
    open override var intrinsicContentSize: CGSize {
        get {
            if let source = self.source {
                return source.size(CGSize.zero)
            }
            return CGSize.zero
        }
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear
        self.contentMode = .center

        self.loader = QImageLoader.shared
    }

    open override func draw(_ rect: CGRect) {
        guard let image = self.image else { return }
        if let context = UIGraphicsGetCurrentContext() {
            var imageRect: CGRect
            let bounds = self.bounds
            if let source = self.source {
                imageRect = source.rect(bounds, image: image)
                switch self.verticalAlignment {
                case .top: imageRect.origin.y = bounds.origin.y
                case .center: imageRect.origin.y = bounds.midY - (imageRect.height / 2)
                case .bottom: imageRect.origin.y = (bounds.origin.y + bounds.height) - imageRect.height
                }
                switch self.horizontalAlignment {
                case .left: imageRect.origin.x = bounds.origin.x
                case .center: imageRect.origin.x = bounds.midX - (imageRect.width / 2)
                case .right: imageRect.origin.x = (bounds.origin.x + bounds.width) - imageRect.width
                }
            } else {
                imageRect = self.bounds
            }
            context.translateBy(x: 0, y: bounds.height)
            context.scaleBy(x: 1.0, y: -1.0)
            switch image.renderingMode {
            case .automatic, .alwaysOriginal:
                if let cgImage = image.cgImage {
                    context.draw(cgImage, in: imageRect)
                }
            case .alwaysTemplate:
                if let tintColor = self.tintColor {
                    if let tintImage = image.tintImage(tintColor) {
                        if let cgTintImage = tintImage.cgImage {
                            context.draw(cgTintImage, in: imageRect)
                        }
                    }
                } else {
                    if let cgImage = image.cgImage {
                        context.draw(cgImage, in: imageRect)
                    }
                }
                break
            }
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if let source = self.source {
            return source.size(size)
        }
        return CGSize.zero
    }

    open override func sizeToFit() {
        var frame = self.frame
        frame.size = self.sizeThatFits(frame.size)
        self.frame = frame
    }

    open func startDownloading() {
        if self.isDownloading == false {
            if let source = self.source, let loader = self.loader, let url = source.url {
                loader.download(url, filter: self.filter, target: self)
                self.isDownloading = true
            }
        }
    }

    open func stopDownloading() {
        if self.isDownloading == true {
            if let loader = self.loader {
                loader.cancel(self)
            }
            self.isDownloading = false
        }
    }
    
    public func apply(_ styleSheet: QImageViewStyleSheet) {
        self.apply(styleSheet as QDisplayViewStyleSheet)
        
        self.verticalAlignment = styleSheet.verticalAlignment
        self.horizontalAlignment = styleSheet.horizontalAlignment
        self.loader = styleSheet.loader
        self.filter = styleSheet.filter
        self.source = styleSheet.source
    }
    
}

extension QImageView : IQImageLoaderTarget {

    open func imageLoader(_ imageLoader: QImageLoader, cacheImage: UIImage) {
        self.image = cacheImage
        self.isDownloading = false
    }

    open func imageLoader(_ imageLoader: QImageLoader, downloadProgress: Progress) {
    }

    open func imageLoader(_ imageLoader: QImageLoader, downloadImage: UIImage) {
        self.image = downloadImage
        self.isDownloading = false
    }

    open func imageLoader(_ imageLoader: QImageLoader, downloadError: Error) {
        self.isDownloading = false
    }

}
