//
//  Quickly
//

open class QPlaceholderImageTitleValueShapeComposable : QComposable {
    
    public var image: QImageViewStyleSheet
    public var imageWidth: CGFloat
    public var imageSpacing: CGFloat
    
    public var title: QPlaceholderViewStyleSheet
    public var titleHeight: CGFloat
    public var titleSpacing: CGFloat = 0
    
    public var value: QPlaceholderViewStyleSheet
    public var valueHeight: CGFloat
    
    public var shape: IQShapeModel
    public var shapeWidth: CGFloat
    public var shapeSpacing: CGFloat
    
    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        image: QImageViewStyleSheet,
        imageWidth: CGFloat = 96,
        imageSpacing: CGFloat = 4,
        title: QPlaceholderViewStyleSheet,
        titleHeight: CGFloat,
        titleSpacing: CGFloat = 4,
        value: QPlaceholderViewStyleSheet,
        valueHeight: CGFloat,
        shape: IQShapeModel,
        shapeWidth: CGFloat = 16,
        shapeSpacing: CGFloat = 4
    ) {
        self.image = image
        self.imageWidth = imageWidth
        self.imageSpacing = titleSpacing
        self.title = title
        self.titleHeight = titleHeight
        self.titleSpacing = titleSpacing
        self.value = value
        self.valueHeight = valueHeight
        self.shape = shape
        self.shapeWidth = shapeWidth
        self.shapeSpacing = shapeSpacing
        super.init(edgeInsets: edgeInsets)
    }
    
}

open class QPlaceholderImageTitleValueShapeComposition< Composable: QPlaceholderImageTitleValueShapeComposable > : QComposition< Composable > {
    
    private lazy var imageView: QImageView = {
        let view = QImageView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var titleLabel: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var valueLabel: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var shapeView: QShapeView = {
        let view = QShapeView(frame: self.contentView.bounds)
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
    private var _shapeWidth: CGFloat?
    private var _shapeSpacing: CGFloat?
    
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    private var _imageConstraints: [NSLayoutConstraint] = [] {
        willSet { self.imageView.removeConstraints(self._imageConstraints) }
        didSet { self.imageView.addConstraints(self._imageConstraints) }
    }
    private var _titleConstraints: [NSLayoutConstraint] = [] {
        willSet { self.titleLabel.removeConstraints(self._titleConstraints) }
        didSet { self.titleLabel.addConstraints(self._titleConstraints) }
    }
    private var _valueConstraints: [NSLayoutConstraint] = [] {
        willSet { self.valueLabel.removeConstraints(self._valueConstraints) }
        didSet { self.valueLabel.addConstraints(self._valueConstraints) }
    }
    private var _shapeConstraints: [NSLayoutConstraint] = [] {
        willSet { self.shapeView.removeConstraints(self._shapeConstraints) }
        didSet { self.shapeView.addConstraints(self._shapeConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let imageSize = composable.image.source.size(CGSize(width: composable.imageWidth, height: availableWidth))
        let shapeSize = composable.shape.size
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(imageSize.height, composable.titleHeight, composable.valueHeight, shapeSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._imageSpacing != composable.imageSpacing || self._titleSpacing != composable.titleSpacing || self._shapeSpacing != composable.shapeSpacing {
            self._edgeInsets = composable.edgeInsets
            self._imageSpacing = composable.imageSpacing
            self._titleSpacing = composable.titleSpacing
            self._shapeSpacing = composable.shapeSpacing
            
            self._constraints = [
                self.imageView.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                self.imageView.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left,
                self.imageView.trailingLayout == self.titleLabel.leadingLayout - composable.imageSpacing,
                self.imageView.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom,
                self.titleLabel.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                self.titleLabel.trailingLayout == self.valueLabel.leadingLayout - composable.titleSpacing,
                self.titleLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom,
                self.valueLabel.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                self.valueLabel.trailingLayout == self.shapeView.leadingLayout - composable.shapeSpacing,
                self.valueLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom,
                self.shapeView.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                self.shapeView.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right,
                self.shapeView.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom
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
                self.titleLabel.heightLayout == composable.titleHeight
            ]
        }
        if self._valueHeight != composable.valueHeight {
            self._valueHeight = composable.valueHeight
            self._valueConstraints = [
                self.valueLabel.heightLayout == composable.valueHeight
            ]
        }
        if self._shapeWidth != composable.shapeWidth {
            self._shapeWidth = composable.shapeWidth
            self._shapeConstraints = [
                self.shapeView.widthLayout == composable.shapeWidth
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.imageView.apply(composable.image)
        self.titleLabel.apply(composable.title)
        self.valueLabel.apply(composable.value)
        self.shapeView.model = composable.shape
    }
    
}
