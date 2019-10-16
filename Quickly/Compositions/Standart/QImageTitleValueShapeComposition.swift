//
//  Quickly
//

open class QImageTitleValueShapeComposable : QComposable {

    public private(set) var imageStyle: QImageViewStyleSheet
    public private(set) var imageWidth: CGFloat
    public private(set) var imageSpacing: CGFloat

    public private(set) var titleStyle: QLabelStyleSheet
    public private(set) var titleSpacing: CGFloat

    public private(set) var valueStyle: QLabelStyleSheet

    public private(set) var shapeModel: QShapeView.Model
    public private(set) var shapeWidth: CGFloat
    public private(set) var shapeSpacing: CGFloat

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        imageStyle: QImageViewStyleSheet,
        imageWidth: CGFloat = 96,
        imageSpacing: CGFloat = 4,
        titleStyle: QLabelStyleSheet,
        titleSpacing: CGFloat = 4,
        valueStyle: QLabelStyleSheet,
        shapeModel: QShapeView.Model,
        shapeWidth: CGFloat = 16,
        shapeSpacing: CGFloat = 4
    ) {
        self.imageStyle = imageStyle
        self.imageWidth = imageWidth
        self.imageSpacing = titleSpacing
        self.titleStyle = titleStyle
        self.titleSpacing = titleSpacing
        self.valueStyle = valueStyle
        self.shapeModel = shapeModel
        self.shapeWidth = shapeWidth
        self.shapeSpacing = shapeSpacing
        super.init(edgeInsets: edgeInsets)
    }

}

open class QImageTitleValueShapeComposition< Composable: QImageTitleValueShapeComposable > : QComposition< Composable > {

    public private(set) lazy var imageView: QImageView = {
        let view = QImageView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var titleView: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var valueView: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(
            horizontal: UILayoutPriority(rawValue: 252),
            vertical: UILayoutPriority(rawValue: 252)
        )
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var shapeView: QShapeView = {
        let view = QShapeView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()

    private var _edgeInsets: UIEdgeInsets?
    private var _imageWidth: CGFloat?
    private var _imageSpacing: CGFloat?
    private var _titleSpacing: CGFloat?
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
    private var _shapeConstraints: [NSLayoutConstraint] = [] {
        willSet { self.shapeView.removeConstraints(self._shapeConstraints) }
        didSet { self.shapeView.addConstraints(self._shapeConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let imageSize = composable.imageStyle.size(CGSize(width: composable.imageWidth, height: availableWidth))
        let valueTextSize = composable.valueStyle.size(width: availableWidth - (composable.imageWidth + composable.imageSpacing + composable.shapeWidth + composable.shapeSpacing))
        let titleTextSize = composable.titleStyle.size(width: availableWidth - (composable.imageWidth + composable.imageSpacing + valueTextSize.width + composable.titleSpacing + composable.shapeWidth + composable.shapeSpacing))
        let shapeSize = composable.shapeModel.size
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(imageSize.height, titleTextSize.height, valueTextSize.height, shapeSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._imageSpacing != composable.imageSpacing || self._titleSpacing != composable.titleSpacing || self._shapeSpacing != composable.shapeSpacing {
            self._edgeInsets = composable.edgeInsets
            self._imageSpacing = composable.imageSpacing
            self._titleSpacing = composable.titleSpacing
            self._shapeSpacing = composable.shapeSpacing
            
            self._constraints = [
                self.imageView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.imageView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.imageView.trailingLayout == self.titleView.leadingLayout.offset(-composable.imageSpacing),
                self.imageView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.titleView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleView.trailingLayout == self.valueView.leadingLayout.offset(-composable.titleSpacing),
                self.titleView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.valueView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.valueView.trailingLayout == self.shapeView.leadingLayout.offset(-composable.shapeSpacing),
                self.valueView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.shapeView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.shapeView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.shapeView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
            ]
        }
        if self._imageWidth != composable.imageWidth {
            self._imageWidth = composable.imageWidth
            self._imageConstraints = [
                self.imageView.widthLayout == composable.imageWidth
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
        self.imageView.apply(composable.imageStyle)
        self.titleView.apply(composable.titleStyle)
        self.valueView.apply(composable.valueStyle)
        self.shapeView.model = composable.shapeModel
    }

}
