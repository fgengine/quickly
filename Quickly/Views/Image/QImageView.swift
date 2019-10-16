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
        case .aspectFit: return bounds.aspectFit(size: size)
        case .aspectFill: return bounds.aspectFill(size: size)
        case .originOrAspectFit: return (bounds.width > size.width) && (bounds.height > size.height) ?
            CGRect(x: bounds.midX - (size.width / 2), y: bounds.midY - (size.height / 2), width: size.width, height: size.height) :
            bounds.aspectFit(size: size)
        case .originOrAspectFill: return (bounds.width > size.width) && (bounds.height > size.height) ?
            CGRect(x: bounds.midX - (size.width / 2), y: bounds.midY - (size.height / 2), width: size.width, height: size.height) :
            bounds.aspectFill(size: size)
        }
    }
    
    public func size(_ available: CGSize, size: CGSize) -> CGSize? {
        let bounds = CGRect(x: 0, y: 0, width: available.width, height: available.height)
        guard let rect = self.rect(bounds, size: size) else { return nil }
        return rect.integral.size
    }
}

// MARK: QImageViewStyleSheet

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
        backgroundColor: UIColor? = nil,
        cornerRadius: QViewCornerRadius = .none,
        border: QViewBorder = .none,
        shadow: QViewShadow? = nil
    ) {
        self.localSource = localSource
        self.remoteSource = remoteSource
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment

        super.init(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            border: border,
            shadow: shadow
        )
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

// MARK: QImageView

open class QImageView : QDisplayView {

    public var progressView: QProgressViewType? {
        didSet {
            if let progressView = self.progressView {
                progressView.progress = 0
                progressView.isHidden = true
            }
        }
    }
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
        didSet(oldValue) {
            if self.localSource != oldValue {
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
    }
    public var remoteSource: QImageRemoteSource? {
        didSet(oldValue) {
            if self.remoteSource != oldValue {
                if let source = self.remoteSource {
                    self._remoteView.image = nil
                    self._remoteView.size = source.size
                    self._remoteView.scale = source.scale
                    self._remoteView.tintColor = source.tintColor
                    self._start(url: source.url, loader: source.loader, filter: source.filter)
                } else {
                    self._remoteView.image = nil
                    self._remoteView.size = nil
                    self._remoteView.scale = .origin
                    self._remoteView.tintColor = nil
                    self._stop()
                }
                self._localView.isHidden = false
                self._remoteView.isHidden = true
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
            loader.cancel(target: self)
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
                loader.cancel(target: self)
            }
        }
        self.loader = loader ?? QImageLoader.shared
        self.loader.download(url: url, filter: filter, target: self)
        self.isDownloading = true
    }
    
    func _stop() {
        if self.isDownloading == true {
            if let loader = self.loader {
                loader.cancel(target: self)
                self.loader = nil
            }
            if let progressView = self.progressView {
                progressView.isHidden = true
            }
            self.isDownloading = false
        }
    }
    
}

extension QImageView : IQImageLoaderTarget {
    
    public func imageLoader(progress: Progress) {
        if let progressView = self.progressView {
            if progressView.isHidden == true {
                progressView.progress = 0
                progressView.isHidden = false
            }
            progressView.setProgress(CGFloat(progress.fractionCompleted), animated: true)
        }
    }
    
    public func imageLoader(image: UIImage) {
        self._remoteView.image = image
        self._localView.isHidden = true
        self._remoteView.isHidden = false
        if let progressView = self.progressView {
            progressView.isHidden = true
        }
        self.isDownloading = false
    }
    
    public func imageLoader(error: Error) {
        self._localView.isHidden = false
        self._remoteView.isHidden = true
        if let progressView = self.progressView {
            progressView.isHidden = true
        }
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
            didSet {
                self._tintImage = nil
                self.setNeedsDisplay()
            }
        }
        var size: CGSize? {
            didSet { self.setNeedsDisplay() }
        }
        
        private var _tintImage: UIImage?
        
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
                    var tintImage: UIImage?
                    if let cacheTintImage = self._tintImage {
                        tintImage = cacheTintImage
                    } else if let realtimeTintImage = image.tintImage(tintColor) {
                        self._tintImage = realtimeTintImage
                        tintImage = realtimeTintImage
                    }
                    if let tintImage = tintImage {
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
