//
//  Quickly
//

public enum QImageViewScale : Int {
    case origin
    case stretch
    case aspectFit
    case aspectFill
    case originOrAspectFit
    case originOrAspectFill
    
    public func rect(_ bounds: CGRect, size: CGSize) -> CGRect? {
        guard bounds.width > CGFloat.leastNonzeroMagnitude && bounds.height > CGFloat.leastNonzeroMagnitude else { return nil }
        guard size.width > CGFloat.leastNonzeroMagnitude && size.height > CGFloat.leastNonzeroMagnitude else { return nil }
        switch self {
        case .origin: return CGRect(origin: bounds.origin, size: size)
        case .stretch: return CGRect(origin: bounds.origin, size: size)
        case .aspectFit: return size.aspectFit(bounds: bounds)
        case .aspectFill: return size.aspectFill(bounds: bounds)
        case .originOrAspectFit: return (bounds.width > size.width) && (bounds.height > size.height) ?
            CGRect(x: bounds.midX - (size.width / 2), y: bounds.midY - (size.height / 2), width: size.width, height: size.height) :
            size.aspectFit(bounds: bounds)
        case .originOrAspectFill: return (bounds.width > size.width) && (bounds.height > size.height) ?
            CGRect(x: bounds.midX - (size.width / 2), y: bounds.midY - (size.height / 2), width: size.width, height: size.height) :
            size.aspectFill(bounds: bounds)
        }
    }
    
    public func size(_ available: CGSize, size: CGSize) -> CGSize? {
        let bounds = CGRect(x: 0, y: 0, width: available.width, height: available.height)
        guard let rect = self.rect(bounds, size: size) else { return nil }
        return rect.integral.size
    }
}

// MARK: - QImageViewStyleSheet -

open class QImageViewStyleSheet : QDisplayStyleSheet {

    public var localSource: QImageLocalSource
    public var remoteSource: QImageRemoteSource?
    public var verticalAlignment: QViewVerticalAlignment
    public var horizontalAlignment: QViewHorizontalAlignment

    public init(
        localSource: QImageLocalSource,
        remoteSource: QImageRemoteSource? = nil,
        verticalAlignment: QViewVerticalAlignment = .center,
        horizontalAlignment: QViewHorizontalAlignment = .center,
        backgroundColor: UIColor? = nil
    ) {
        self.localSource = localSource
        self.remoteSource = remoteSource
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment

        super.init(backgroundColor: backgroundColor)
    }

    public init(_ styleSheet: QImageViewStyleSheet) {
        self.localSource = styleSheet.localSource
        self.remoteSource = styleSheet.remoteSource
        self.verticalAlignment = styleSheet.verticalAlignment
        self.horizontalAlignment = styleSheet.horizontalAlignment

        super.init(styleSheet)
    }
    
    public func size(_ available: CGSize) -> CGSize {
        return self.localSource.size(available)
    }

}

// MARK: - QImageView -

open class QImageView : QDisplayView {

    public var verticalAlignment: QViewVerticalAlignment = .center {
        didSet {
            self._localView.verticalAlignment = self.verticalAlignment
            self._remoteView.verticalAlignment = self.verticalAlignment
        }
    }
    public var horizontalAlignment: QViewHorizontalAlignment = .center {
        didSet {
            self._localView.horizontalAlignment = self.horizontalAlignment
            self._remoteView.horizontalAlignment = self.horizontalAlignment
        }
    }
    public var localSource: QImageLocalSource? {
        didSet {
            if let source = self.localSource {
                self._localView.image = source.image
                self._localView.size = source.size
                self._localView.scale = source.scale
                self._localView.tintColor = source.tintColor
            } else {
                self._localView.image = nil
                self._localView.size = nil
                self._localView.scale = .origin
                self._localView.tintColor = nil
            }
        }
    }
    public var remoteSource: QImageRemoteSource? {
        didSet {
            if let source = self.remoteSource {
                self._remoteView.size = source.size
                self._remoteView.scale = source.scale
                self._remoteView.tintColor = source.tintColor
                self._start(url: source.url, loader: source.loader, filter: source.filter)
            } else {
                self._remoteView.size = nil
                self._remoteView.scale = .origin
                self._remoteView.tintColor = nil
                self._stop()
            }
        }
    }
    open private(set) var isDownloading: Bool = false
    open private(set) var loader: QImageLoader!
    open override var frame: CGRect {
        set(value) {
            if(super.frame != value) {
                let sizeChanged = super.frame.size != value.size
                super.frame = value
                if sizeChanged == true {
                    self.invalidateIntrinsicContentSize()
                    self.setNeedsDisplay()
                }
            }
        }
        get { return super.frame }
    }
    open override var bounds: CGRect {
        set(value) {
            if(super.bounds != value) {
                let sizeChanged = super.bounds.size != value.size
                super.bounds = value
                if sizeChanged == true {
                    self.invalidateIntrinsicContentSize()
                    self.setNeedsDisplay()
                }
            }
        }
        get { return super.bounds }
    }
    open override var intrinsicContentSize: CGSize {
        get { return self.sizeThatFits(CGSize.zero) }
    }

    private var _localView: View!
    private var _remoteView: View!
    
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
    
    deinit {
        if let loader = self.loader {
            loader.cancel(self)
        }
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear
        
        self._localView = View(frame: self.bounds)
        self._localView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self._localView.verticalAlignment = self.verticalAlignment
        self._localView.horizontalAlignment = self.horizontalAlignment
        self.addSubview(self._localView)
        
        self._remoteView = View(frame: self.bounds)
        self._remoteView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self._remoteView.verticalAlignment = self.verticalAlignment
        self._remoteView.horizontalAlignment = self.horizontalAlignment
        self._remoteView.isHidden = true
        self.addSubview(self._remoteView)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var currentImage: UIImage?
        var currentScale: QImageViewScale
        if let remoteImage = self._remoteView.image {
            currentImage = remoteImage
            currentScale = self._remoteView.scale
        } else {
            currentImage = self._localView.image
            currentScale = self._localView.scale
        }
        if let image = currentImage {
            guard let size = currentScale.size(size, size: image.size) else {
                return image.size.ceil()
            }
            return size
        }
        return CGSize.zero
    }
    
    open override func sizeToFit() {
        var frame = self.frame
        frame.size = self.sizeThatFits(frame.size)
        self.frame = frame
    }
    
    public func apply(_ styleSheet: QImageViewStyleSheet) {
        self.apply(styleSheet as QDisplayStyleSheet)
        
        self.verticalAlignment = styleSheet.verticalAlignment
        self.horizontalAlignment = styleSheet.horizontalAlignment
        self.localSource = styleSheet.localSource
        self.remoteSource = styleSheet.remoteSource
    }
    
}

private extension QImageView {
    
    func _start(url: URL, loader: QImageLoader?, filter: IQImageLoaderFilter?) {
        if self.isDownloading == true {
            if let loader = self.loader {
                loader.cancel(self)
            }
        }
        self.loader = loader ?? QImageLoader.shared
        self.loader.download(url, filter: filter, target: self)
        self.isDownloading = true
        self._remoteView.isHidden = true
    }
    
    func _stop() {
        if self.isDownloading == true {
            if let loader = self.loader {
                loader.cancel(self)
                self.loader = nil
            }
            self.isDownloading = false
            self._remoteView.isHidden = true
        }
    }
    
}

extension QImageView : IQImageLoaderTarget {
    
    public func imageLoader(_ imageLoader: QImageLoader, cacheImage: UIImage) {
        self._remoteView.image = cacheImage
        self._localView.isHidden = true
        self._remoteView.isHidden = false
        self.isDownloading = false
    }
    
    public func imageLoader(_ imageLoader: QImageLoader, downloadProgress: Progress) {
    }
    
    public func imageLoader(_ imageLoader: QImageLoader, downloadImage: UIImage) {
        self._remoteView.image = downloadImage
        self._localView.isHidden = true
        self._remoteView.isHidden = false
        self.isDownloading = false
    }
    
    public func imageLoader(_ imageLoader: QImageLoader, downloadError: Error) {
        self._localView.isHidden = false
        self._remoteView.isHidden = true
        self.isDownloading = false
    }
    
}

private extension QImageView {
    
    class View : UIView {
        
        var verticalAlignment: QViewVerticalAlignment {
            didSet { self.setNeedsDisplay() }
        }
        var horizontalAlignment: QViewHorizontalAlignment {
            didSet { self.setNeedsDisplay() }
        }
        var scale: QImageViewScale {
            didSet { self.setNeedsDisplay() }
        }
        var image: UIImage? {
            didSet { self.setNeedsDisplay() }
        }
        var size: CGSize? {
            didSet { self.setNeedsDisplay() }
        }
        
        override init(frame: CGRect) {
            self.verticalAlignment = .center
            self.horizontalAlignment = .center
            self.scale = .origin
            super.init(frame: frame)
            self.backgroundColor = UIColor.clear
            self.contentMode = .scaleAspectFit
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ rect: CGRect) {
            guard let context = UIGraphicsGetCurrentContext(), let image = self.image else { return }
            let bounds = self.bounds
            let imageRect: CGRect
            if var scaleRect = self.scale.rect(bounds, size: self.size ?? image.size) {
                switch self.verticalAlignment {
                case .top: scaleRect.origin.y = bounds.origin.y
                case .center: scaleRect.origin.y = bounds.midY - (scaleRect.height / 2)
                case .bottom: scaleRect.origin.y = (bounds.origin.y + bounds.height) - scaleRect.height
                }
                switch self.horizontalAlignment {
                case .left: scaleRect.origin.x = bounds.origin.x
                case .center: scaleRect.origin.x = bounds.midX - (scaleRect.width / 2)
                case .right: scaleRect.origin.x = (bounds.origin.x + bounds.width) - scaleRect.width
                }
                imageRect = scaleRect
            } else {
                imageRect = bounds
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
            @unknown default:
                if let cgImage = image.cgImage {
                    context.draw(cgImage, in: imageRect)
                }
            }
        }
        
    }
    
}
