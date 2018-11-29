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

    lazy private var imageView: QImageView = {
        let view = QImageView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    lazy private var titleLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()

    private var currentDirection: QViewDirection?
    private var currentEdgeInsets: UIEdgeInsets?
    private var currentImageSpacing: CGFloat?
    private var currentImageSize: CGSize?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    private var imageConstraints: [NSLayoutConstraint] = [] {
        willSet { self.imageView.removeConstraints(self.imageConstraints) }
        didSet { self.imageView.addConstraints(self.imageConstraints) }
    }

    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerAvailableSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
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
        let changedDirection = self.currentDirection != composable.direction
        self.currentDirection = composable.direction
        
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        let changedEdgeInsets = self.currentEdgeInsets != edgeInsets
        self.currentEdgeInsets = edgeInsets
        
        let changedImageSpacing = self.currentImageSpacing != composable.imageSpacing
        self.currentImageSpacing = composable.imageSpacing
        
        let changedImageSize = self.currentImageSize != composable.imageSize
        self.currentImageSize = composable.imageSize
        
        if changedDirection == true || changedEdgeInsets == true || changedImageSpacing == true {
            switch composable.direction {
            case .horizontal:
                self.selfConstraints = [
                    self.imageView.topLayout == self.contentView.topLayout + edgeInsets.top,
                    self.imageView.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                    self.imageView.trailingLayout == self.titleLabel.leadingLayout - composable.imageSpacing,
                    self.imageView.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom,
                    self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top,
                    self.titleLabel.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                    self.titleLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom
                ]
            case .vertical:
                self.selfConstraints = [
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
                self.imageConstraints = [
                    self.imageView.widthLayout == composable.imageSize.width
                ]
            case .vertical:
                self.imageConstraints = [
                    self.imageView.heightLayout == composable.imageSize.height
                ]
            }
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        composable.image.apply(self.imageView)
        composable.title.apply(self.titleLabel)
    }

}
