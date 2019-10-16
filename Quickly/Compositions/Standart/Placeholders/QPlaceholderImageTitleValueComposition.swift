//
//  Quickly
//

open class QPlaceholderImageTitleValueComposable : QComposable {
    
    public private(set) var imageStyle: QImageViewStyleSheet
    public private(set) var imageWidth: CGFloat
    public private(set) var imageSpacing: CGFloat
    
    public private(set) var titleStyle: QPlaceholderStyleSheet
    public private(set) var titleHeight: CGFloat
    public private(set) var titleSpacing: CGFloat
    
    public private(set) var valueStyle: QPlaceholderStyleSheet
    public private(set) var valueHeight: CGFloat
    
    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        imageStyle: QImageViewStyleSheet,
        imageWidth: CGFloat = 96,
        imageSpacing: CGFloat = 4,
        titleStyle: QPlaceholderStyleSheet,
        titleHeight: CGFloat,
        titleSpacing: CGFloat = 4,
        valueStyle: QPlaceholderStyleSheet,
        valueHeight: CGFloat
    ) {
        self.imageStyle = imageStyle
        self.imageWidth = imageWidth
        self.imageSpacing = imageSpacing
        self.titleStyle = titleStyle
        self.titleHeight = titleHeight
        self.titleSpacing = titleSpacing
        self.valueStyle = valueStyle
        self.valueHeight = valueHeight
        super.init(edgeInsets: edgeInsets)
    }
    
}

open class QPlaceholderImageTitleValueComposition< Composable: QPlaceholderImageTitleValueComposable > : QComposition< Composable > {
    
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
    private var _valueHeight: CGFloat?
    
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
    private var _valueConstraints: [NSLayoutConstraint] = [] {
        willSet { self.valueView.removeConstraints(self._valueConstraints) }
        didSet { self.valueView.addConstraints(self._valueConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let imageSize = composable.imageStyle.size(CGSize(width: composable.imageWidth, height: availableWidth))
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(imageSize.height, composable.titleHeight, composable.valueHeight) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._imageSpacing != composable.imageSpacing || self._titleSpacing != composable.titleSpacing {
            self._edgeInsets = composable.edgeInsets
            self._imageSpacing = composable.imageSpacing
            self._titleSpacing = composable.titleSpacing
            self._constraints = [
                self.imageView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.imageView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.imageView.trailingLayout == self.titleView.leadingLayout.offset(-composable.imageSpacing),
                self.imageView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.titleView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleView.trailingLayout == self.valueView.leadingLayout.offset(-composable.titleSpacing),
                self.titleView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.valueView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.valueView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.valueView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
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
        if self._valueHeight != composable.valueHeight {
            self._valueHeight = composable.valueHeight
            self._valueConstraints = [
                self.valueView.heightLayout == composable.valueHeight
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.imageView.apply(composable.imageStyle)
        self.titleView.apply(composable.titleStyle)
        self.valueView.apply(composable.valueStyle)
    }
    
}
