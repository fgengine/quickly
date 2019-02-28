//
//  Quickly
//

open class QImageTitleComposable : QComposable {

    public var direction: QViewDirection
    
    public var image: QImageViewStyleSheet
    public var imageSize: CGSize
    public var imageSpacing: CGFloat

    public var title: QLabelStyleSheet

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        image: QImageViewStyleSheet,
        imageWidth: CGFloat = 96,
        imageSpacing: CGFloat = 4,
        title: QLabelStyleSheet
    ) {
        self.direction = .horizontal
        self.image = image
        self.imageSize = CGSize(width: imageWidth, height: imageWidth)
        self.imageSpacing = imageSpacing
        self.title = title
        super.init(edgeInsets: edgeInsets)
    }
    
    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        image: QImageViewStyleSheet,
        imageHeight: CGFloat = 96,
        imageSpacing: CGFloat = 8,
        title: QLabelStyleSheet
    ) {
        self.direction = .vertical
        self.image = image
        self.imageSize = CGSize(width: imageHeight, height: imageHeight)
        self.imageSpacing = imageSpacing
        self.title = title
        super.init(edgeInsets: edgeInsets)
    }

}

open class QImageTitleComposition< Composable: QImageTitleComposable > : QComposition< Composable > {

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

    private var _direction: QViewDirection?
    private var _edgeInsets: UIEdgeInsets?
    private var _imageSpacing: CGFloat?
    private var _imageSize: CGSize?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    private var _imageConstraints: [NSLayoutConstraint] = [] {
        willSet { self.imageView.removeConstraints(self._imageConstraints) }
        didSet { self.imageView.addConstraints(self._imageConstraints) }
    }

    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        switch composable.direction {
        case .horizontal:
            let imageSize = composable.image.source.size(CGSize(width: composable.imageSize.width, height: availableWidth))
            let titleTextSize = composable.title.text.size(width: availableWidth - (composable.imageSize.width + composable.imageSpacing))
            return CGSize(
                width: spec.containerSize.width,
                height: composable.edgeInsets.top + max(imageSize.height, titleTextSize.height) + composable.edgeInsets.bottom
            )
        case .vertical:
            let imageSize = composable.imageSize
            let titleTextSize = composable.title.text.size(width: availableWidth)
            return CGSize(
                width: composable.edgeInsets.left + max(imageSize.width, titleTextSize.width) + composable.edgeInsets.right,
                height: composable.edgeInsets.top + imageSize.height + composable.imageSpacing + titleTextSize.height + composable.edgeInsets.bottom
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
        
        if changedDirection == true || changedEdgeInsets == true || changedImageSpacing == true {
            switch composable.direction {
            case .horizontal:
                self._constraints = [
                    self.imageView.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                    self.imageView.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left,
                    self.imageView.trailingLayout == self.titleLabel.leadingLayout - composable.imageSpacing,
                    self.imageView.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom,
                    self.titleLabel.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                    self.titleLabel.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right,
                    self.titleLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom
                ]
            case .vertical:
                self._constraints = [
                    self.imageView.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                    self.imageView.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left,
                    self.imageView.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right,
                    self.imageView.bottomLayout == self.titleLabel.topLayout - composable.edgeInsets.bottom,
                    self.titleLabel.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left,
                    self.titleLabel.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right,
                    self.titleLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom
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
                    self.imageView.heightLayout == composable.imageSize.height
                ]
            }
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.imageView.apply(composable.image)
        self.titleLabel.apply(composable.title)
    }

}
