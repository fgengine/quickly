//
//  Quickly
//

open class QPlaceholderImageTitleComposable : QComposable {

    public var direction: QViewDirection
    
    public var image: QImageViewStyleSheet
    public var imageSize: CGSize
    public var imageSpacing: CGFloat

    public var title: QPlaceholderViewStyleSheet
    public var titleHeight: CGFloat

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        image: QImageViewStyleSheet,
        imageWidth: CGFloat = 96,
        imageSpacing: CGFloat = 4,
        title: QPlaceholderViewStyleSheet,
        titleHeight: CGFloat
    ) {
        self.direction = .horizontal
        self.image = image
        self.imageSize = CGSize(width: imageWidth, height: imageWidth)
        self.imageSpacing = imageSpacing
        self.title = title
        self.titleHeight = titleHeight
        super.init(edgeInsets: edgeInsets)
    }
    
    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        image: QImageViewStyleSheet,
        imageHeight: CGFloat = 96,
        imageSpacing: CGFloat = 8,
        title: QPlaceholderViewStyleSheet,
        titleHeight: CGFloat
    ) {
        self.direction = .vertical
        self.image = image
        self.imageSize = CGSize(width: imageHeight, height: imageHeight)
        self.imageSpacing = imageSpacing
        self.title = title
        self.titleHeight = titleHeight
        super.init(edgeInsets: edgeInsets)
    }

}

open class QPlaceholderImageTitleComposition< Composable: QPlaceholderImageTitleComposable > : QComposition< Composable > {

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

    private var _direction: QViewDirection?
    private var _edgeInsets: UIEdgeInsets?
    private var _imageSpacing: CGFloat?
    private var _imageSize: CGSize?
    private var _titleHeight: CGFloat?

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

    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        switch composable.direction {
        case .horizontal:
            return CGSize(
                width: spec.containerSize.width,
                height: composable.edgeInsets.top + max(composable.imageSize.height, composable.titleHeight) + composable.edgeInsets.bottom
            )
        case .vertical:
            return CGSize(
                width: composable.edgeInsets.left + composable.imageSize.width + composable.edgeInsets.right,
                height: composable.edgeInsets.top + composable.imageSize.height + composable.imageSpacing + composable.titleHeight + composable.edgeInsets.bottom
            )
        }
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        let changedDirection = self._direction != composable.direction
        self._direction = composable.direction
        
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        let changedEdgeInsets = self._edgeInsets != edgeInsets
        self._edgeInsets = edgeInsets
        
        let changedImageSpacing = self._imageSpacing != composable.imageSpacing
        self._imageSpacing = composable.imageSpacing
        
        let changedImageSize = self._imageSize != composable.imageSize
        self._imageSize = composable.imageSize
        
        let changedTitleHeight = self._titleHeight != composable.titleHeight
        self._titleHeight = composable.titleHeight
        
        if changedDirection == true || changedEdgeInsets == true || changedImageSpacing == true {
            switch composable.direction {
            case .horizontal:
                self._constraints = [
                    self.imageView.topLayout == self.contentView.topLayout + edgeInsets.top,
                    self.imageView.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                    self.imageView.trailingLayout == self.titleLabel.leadingLayout - composable.imageSpacing,
                    self.imageView.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom,
                    self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top,
                    self.titleLabel.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                    self.titleLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom
                ]
            case .vertical:
                self._constraints = [
                    self.imageView.topLayout == self.contentView.topLayout + edgeInsets.top,
                    self.imageView.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                    self.imageView.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                    self.imageView.bottomLayout == self.titleLabel.topLayout - edgeInsets.bottom,
                    self.titleLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                    self.titleLabel.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                    self.titleLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom
                ]
            }
        }
        if changedDirection == true || changedImageSize == true {
            switch composable.direction {
            case .horizontal:
                self._imageConstraints = [
                    self.imageView.widthLayout == composable.imageSize.width
                ]
            case .vertical:
                self._imageConstraints = [
                    self.imageView.widthLayout == composable.imageSize.width,
                    self.imageView.heightLayout == composable.imageSize.height
                ]
            }
        }
        if changedDirection == true || changedTitleHeight == true {
            self._titleConstraints = [
                self.titleLabel.heightLayout == composable.titleHeight
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.imageView.apply(composable.image)
        self.titleLabel.apply(composable.title)
    }

}
