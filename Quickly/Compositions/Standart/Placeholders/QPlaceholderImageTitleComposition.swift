//
//  Quickly
//

open class QPlaceholderImageTitleComposable : QComposable {

    public private(set) var direction: QViewDirection
    
    public private(set) var imageStyle: QImageViewStyleSheet
    public private(set) var imageSize: CGSize
    public private(set) var imageSpacing: CGFloat

    public private(set) var titleStyle: QPlaceholderStyleSheet
    public private(set) var titleHeight: CGFloat

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        imageStyle: QImageViewStyleSheet,
        imageWidth: CGFloat = 96,
        imageSpacing: CGFloat = 4,
        titleStyle: QPlaceholderStyleSheet,
        titleHeight: CGFloat
    ) {
        self.direction = .horizontal
        self.imageStyle = imageStyle
        self.imageSize = CGSize(width: imageWidth, height: imageWidth)
        self.imageSpacing = imageSpacing
        self.titleStyle = titleStyle
        self.titleHeight = titleHeight
        super.init(edgeInsets: edgeInsets)
    }
    
    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        imageStyle: QImageViewStyleSheet,
        imageHeight: CGFloat = 96,
        imageSpacing: CGFloat = 8,
        titleStyle: QPlaceholderStyleSheet,
        titleHeight: CGFloat
    ) {
        self.direction = .vertical
        self.imageStyle = imageStyle
        self.imageSize = CGSize(width: imageHeight, height: imageHeight)
        self.imageSpacing = imageSpacing
        self.titleStyle = titleStyle
        self.titleHeight = titleHeight
        super.init(edgeInsets: edgeInsets)
    }

}

open class QPlaceholderImageTitleComposition< Composable: QPlaceholderImageTitleComposable > : QComposition< Composable > {

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
        willSet { self.titleView.removeConstraints(self._titleConstraints) }
        didSet { self.titleView.addConstraints(self._titleConstraints) }
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
        
        let changedEdgeInsets = self._edgeInsets != composable.edgeInsets
        self._edgeInsets = composable.edgeInsets
        
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
                    self.imageView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                    self.imageView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                    self.imageView.trailingLayout == self.titleView.leadingLayout.offset(-composable.imageSpacing),
                    self.imageView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                    self.titleView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                    self.titleView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                    self.titleView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
                ]
            case .vertical:
                self._constraints = [
                    self.imageView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                    self.imageView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                    self.imageView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                    self.imageView.bottomLayout == self.titleView.topLayout.offset(-composable.edgeInsets.bottom),
                    self.titleView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                    self.titleView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                    self.titleView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
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
                self.titleView.heightLayout == composable.titleHeight
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.imageView.apply(composable.imageStyle)
        self.titleView.apply(composable.titleStyle)
    }

}
