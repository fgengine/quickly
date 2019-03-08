//
//  Quickly
//

open class QImageTitleShapeComposable : QComposable {

    public var image: QImageViewStyleSheet
    public var imageWidth: CGFloat
    public var imageSpacing: CGFloat

    public var title: QLabelStyleSheet

    public var shape: QShapeView.Model
    public var shapeWidth: CGFloat
    public var shapeSpacing: CGFloat

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        image: QImageViewStyleSheet,
        imageWidth: CGFloat = 96,
        imageSpacing: CGFloat = 4,
        title: QLabelStyleSheet,
        shape: QShapeView.Model,
        shapeWidth: CGFloat = 16,
        shapeSpacing: CGFloat = 4
    ) {
        self.image = image
        self.imageWidth = imageWidth
        self.imageSpacing = imageSpacing
        self.title = title
        self.shape = shape
        self.shapeWidth = shapeWidth
        self.shapeSpacing = shapeSpacing
        super.init(edgeInsets: edgeInsets)
    }

}

open class QImageTitleShapeComposition< Composable: QImageTitleShapeComposable >: QComposition< Composable > {

    private lazy var imageView: QImageView = {
        let view = QImageView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var titleLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
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
        let imageSize = composable.image.source.size(CGSize(width: composable.imageWidth, height: availableWidth))
        let titleTextSize = composable.title.text.size(width: availableWidth - (composable.imageWidth + composable.imageSpacing + composable.shapeWidth + composable.shapeSpacing))
        let shapeSize = composable.shape.size
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(imageSize.height, titleTextSize.height, shapeSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._imageSpacing != composable.imageSpacing || self._shapeSpacing != composable.shapeSpacing {
            self._edgeInsets = composable.edgeInsets
            self._imageSpacing = composable.imageSpacing
            self._shapeSpacing = composable.shapeSpacing
            self._constraints = [
                self.imageView.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                self.imageView.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left,
                self.imageView.trailingLayout == self.titleLabel.leadingLayout - composable.imageSpacing,
                self.imageView.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom,
                self.titleLabel.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                self.titleLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom,
                self.shapeView.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                self.shapeView.leadingLayout == self.titleLabel.trailingLayout + composable.shapeSpacing,
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
        self.shapeView.model = composable.shape
    }

}
