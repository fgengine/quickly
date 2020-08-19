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
            self._localLayer.set(
                verticalAlignment: self.verticalAlignment,
                horizontalAlignment: self.horizontalAlignment
            )
            self._remoteLayer.set(
                verticalAlignment: self.verticalAlignment,
                horizontalAlignment: self.horizontalAlignment
            )
            self.setNeedsLayout()
        }
    }
    public var horizontalAlignment: QViewHorizontalAlignment = .center {
        didSet {
            self._localLayer.set(
                verticalAlignment: self.verticalAlignment,
                horizontalAlignment: self.horizontalAlignment
            )
            self._remoteLayer.set(
                verticalAlignment: self.verticalAlignment,
                horizontalAlignment: self.horizontalAlignment
            )
            self.setNeedsLayout()
        }
    }
    public var localSource: QImageLocalSource? {
        didSet(oldValue) {
            if self.localSource != oldValue {
                self._localLayer.set(
                    scale: self.localSource?.scale,
                    size: self.localSource?.size,
                    image: self.localSource?.image,
                    tintColor: self.localSource?.tintColor
                )
                self.setNeedsLayout()
            }
        }
    }
    public var remoteSource: QImageRemoteSource? {
        didSet(oldValue) {
            if self.remoteSource != oldValue {
                if let source = self.remoteSource {
                    self._start(url: source.url, loader: source.loader, filter: source.filter)
                } else {
                    self._stop()
                }
                self._localLayer.isHidden = false
                self._remoteLayer.isHidden = true
                self.setNeedsLayout()
            }
        }
    }
    open private(set) var isDownloading: Bool = false
    open private(set) var loader: QImageLoader!
    open override var frame: CGRect {
        set(value) {
            let sizeChanged = super.frame.size != value.size
            super.frame = value
            if sizeChanged == true {
                self.invalidateIntrinsicContentSize()
                self.setNeedsLayout()
            }
        }
        get { return super.frame }
    }
    open override var bounds: CGRect {
        set(value) {
            let sizeChanged = super.bounds.size != value.size
            super.bounds = value
            if sizeChanged == true {
                self.invalidateIntrinsicContentSize()
                self.setNeedsLayout()
            }
        }
        get { return super.bounds }
    }
    open override var intrinsicContentSize: CGSize {
        get { return self.sizeThatFits(CGSize.zero) }
    }

    private var _localLayer: Layer!
    private var _remoteLayer: Layer!
    
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
        
        self._localLayer = Layer()
        self._localLayer.set(
            verticalAlignment: self.verticalAlignment,
            horizontalAlignment: self.horizontalAlignment
        )
        self.layer.addSublayer(self._localLayer)
        
        self._remoteLayer = Layer()
        self._remoteLayer.set(
            verticalAlignment: self.verticalAlignment,
            horizontalAlignment: self.horizontalAlignment
        )
        self._remoteLayer.isHidden = true
        self.layer.addSublayer(self._remoteLayer)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        self._localLayer.layout(bounds: bounds)
        self._remoteLayer.layout(bounds: bounds)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var currentScale: QImageViewScale?
        var currentImage: UIImage?
        if let remoteImage = self._remoteLayer.image {
            currentScale = self._remoteLayer.scale
            currentImage = remoteImage
        } else {
            currentScale = self._localLayer.scale
            currentImage = self._localLayer.image
        }
        if let scale = currentScale, let image = currentImage {
            guard let size = scale.size(size, size: image.size) else {
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
        self._remoteLayer.set(
            scale: self.remoteSource?.scale,
            size: self.remoteSource?.size,
            image: image,
            tintColor: self.remoteSource?.tintColor
        )
        self._localLayer.isHidden = true
        self._remoteLayer.isHidden = false
        if let progressView = self.progressView {
            progressView.isHidden = true
        }
        self.isDownloading = false
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    public func imageLoader(error: Error) {
        self._localLayer.isHidden = false
        self._remoteLayer.isHidden = true
        if let progressView = self.progressView {
            progressView.isHidden = true
        }
        self.isDownloading = false
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
}

private extension QImageView {
    
    class Layer : CALayer {
        
        private(set) var verticalAlignment: QViewVerticalAlignment
        private(set) var horizontalAlignment: QViewHorizontalAlignment
        private(set) var scale: QImageViewScale?
        private(set) var size: CGSize?
        private(set) var image: UIImage?
        private(set) var tintColor: UIColor?
        override var frame: CGRect {
            set(value) {
                super.frame = value
                self.mask?.frame = self.bounds
            }
            get { return super.frame }
        }
        
        override init() {
            self.verticalAlignment = .center
            self.horizontalAlignment = .center
            super.init()
        }
        
        override init(layer: Any) {
            guard let layer = layer as? Layer else {
                fatalError("init(layer:) invalid copy layer")
            }
            self.verticalAlignment = layer.verticalAlignment
            self.horizontalAlignment = layer.horizontalAlignment
            super.init(layer: layer)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func layout(bounds: CGRect) {
            self.frame = self._frame(bounds: bounds)
        }
        
        func set(
            verticalAlignment: QViewVerticalAlignment,
            horizontalAlignment: QViewHorizontalAlignment
        ) {
            self.verticalAlignment = verticalAlignment
            self.horizontalAlignment = horizontalAlignment
        }
        
        func set(
            scale: QImageViewScale?,
            size: CGSize?,
            image: UIImage?,
            tintColor: UIColor?
        ) {
            self.scale = scale
            self.size = size
            self.image = image
            self.tintColor = tintColor
            if let image = image {
                if let tintColor = self.tintColor {
                    let maskLayer = CALayer()
                    maskLayer.frame = self.bounds
                    maskLayer.contents = image.cgImage
                    self.mask = maskLayer
                    self.contents = nil
                    self.backgroundColor = tintColor.cgColor
                } else {
                    self.mask = nil
                    self.contents = image.cgImage
                    self.backgroundColor = nil
                }
            } else {
                self.mask = nil
                self.contents = nil
            }
        }
        
    }
    
}

private extension QImageView.Layer {
    
    func _frame(bounds: CGRect) -> CGRect {
        let imageRect: CGRect
        if let image = self.image, let scale = self.scale, var scaleRect = scale.rect(bounds, size: self.size ?? image.size) {
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
        return imageRect
    }
    
}
