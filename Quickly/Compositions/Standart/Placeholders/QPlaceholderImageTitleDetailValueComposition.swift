//
//  Quickly
//

open class QPlaceholderImageTitleDetailValueComposable : QComposable {
    
    public var imageStyle: QImageViewStyleSheet
    public var imageWidth: CGFloat
    public var imageSpacing: CGFloat
    
    public var titleStyle: QPlaceholderStyleSheet
    public var titleHeight: CGFloat
    public var titleSpacing: CGFloat
    
    public var detailStyle: QPlaceholderStyleSheet
    public var detailHeight: CGFloat
    
    public var valueStyle: QPlaceholderStyleSheet
    public var valueSize: CGSize
    public var valueSpacing: CGFloat
    
    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        imageStyle: QImageViewStyleSheet,
        imageWidth: CGFloat = 96,
        imageSpacing: CGFloat = 4,
        titleStyle: QPlaceholderStyleSheet,
        titleHeight: CGFloat,
        titleSpacing: CGFloat = 4,
        detailStyle: QPlaceholderStyleSheet,
        detailHeight: CGFloat,
        valueStyle: QPlaceholderStyleSheet,
        valueSize: CGSize,
        valueSpacing: CGFloat = 4
    ) {
        self.imageStyle = imageStyle
        self.imageWidth = imageWidth
        self.imageSpacing = imageSpacing
        self.titleStyle = titleStyle
        self.titleHeight = titleHeight
        self.titleSpacing = titleSpacing
        self.detailStyle = detailStyle
        self.detailHeight = detailHeight
        self.valueStyle = valueStyle
        self.valueSize = valueSize
        self.valueSpacing = valueSpacing
        super.init(edgeInsets: edgeInsets)
    }
    
}

open class QPlaceholderImageTitleDetailValueComposition< Composable: QPlaceholderImageTitleDetailValueComposable > : QComposition< Composable > {
    
    public private(set) lazy var imageView: QImageView = {
        let view = QImageView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var titleView: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var detailView: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var valueView: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    
    private var _edgeInsets: UIEdgeInsets?
    private var _imageWidth: CGFloat?
    private var _imageSpacing: CGFloat?
    private var _titleHeight: CGFloat?
    private var _titleSpacing: CGFloat?
    private var _detailHeight: CGFloat?
    private var _valueSize: CGSize?
    private var _valueSpacing: CGFloat?
    
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    private var _imageConstraints: [NSLayoutConstraint] = [] {
        willSet { self.imageView.removeConstraints(self._imageConstraints) }
        didSet { self.imageView.addConstraints(self._imageConstraints) }
    }
    private var _titleConstraints: [NSLayoutConstraint] = [] {
        willSet { self.titleView.removeConstraints(self._titleConstraints) }
        didSet { self.titleView.addConstraints(self._titleConstraints) }
    }
    private var _detailConstraints: [NSLayoutConstraint] = [] {
        willSet { self.detailView.removeConstraints(self._detailConstraints) }
        didSet { self.detailView.addConstraints(self._detailConstraints) }
    }
    private var _valueConstraints: [NSLayoutConstraint] = [] {
        willSet { self.valueView.removeConstraints(self._valueConstraints) }
        didSet { self.valueView.addConstraints(self._valueConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let imageSize = composable.imageStyle.size(CGSize(width: composable.imageWidth, height: availableWidth))
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(imageSize.height, composable.titleHeight + composable.titleSpacing + composable.detailHeight, composable.valueSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._imageSpacing != composable.imageSpacing || self._titleSpacing != composable.titleSpacing || self._valueSpacing != composable.valueSpacing {
            self._edgeInsets = composable.edgeInsets
            self._imageSpacing = composable.imageSpacing
            self._titleSpacing = composable.titleSpacing
            self._valueSpacing = composable.valueSpacing
            self._constraints = [
                self.imageView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.imageView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.imageView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.titleView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleView.leadingLayout == self.imageView.trailingLayout.offset(composable.imageSpacing),
                self.titleView.trailingLayout == self.valueView.leadingLayout.offset(-composable.valueSpacing),
                self.titleView.bottomLayout <= self.detailView.topLayout.offset(-composable.titleSpacing),
                self.detailView.leadingLayout == self.imageView.trailingLayout.offset(composable.imageSpacing),
                self.detailView.trailingLayout == self.valueView.leadingLayout.offset(-composable.valueSpacing),
                self.detailView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.valueView.topLayout >= self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.valueView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.valueView.bottomLayout <= self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.valueView.centerYLayout == self.contentView.centerYLayout
            ]
        }
        if self._imageWidth != composable.imageWidth {
            self._imageWidth = composable.imageWidth
            self._imageConstraints = [
                self.imageView.widthLayout == composable.imageWidth
            ]
        }
        if self._titleHeight != composable.titleHeight {
            self._titleHeight = composable.titleHeight
            self._titleConstraints = [
                self.titleView.heightLayout == composable.titleHeight
            ]
        }
        if self._detailHeight != composable.detailHeight {
            self._detailHeight = composable.detailHeight
            self._detailConstraints = [
                self.detailView.heightLayout == composable.detailHeight
            ]
        }
        if self._valueSize != composable.valueSize {
            self._valueSize = composable.valueSize
            self._valueConstraints = [
                self.valueView.widthLayout == composable.valueSize.width,
                self.valueView.heightLayout == composable.valueSize.height
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.imageView.apply(composable.imageStyle)
        self.titleView.apply(composable.titleStyle)
        self.detailView.apply(composable.detailStyle)
        self.valueView.apply(composable.valueStyle)
    }
    
}
