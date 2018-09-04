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
        edgeInsets: UIEdgeInsets = QComposable.defaultEdgeInsets,
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
        edgeInsets: UIEdgeInsets = QComposable.defaultEdgeInsets,
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

    public private(set) var imageView: QImageView!
    public private(set) var titleLabel: QLabel!

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
            let imageSize = composable.image.source.size(CGSize(width: composable.imageSize.width, height: availableWidth)).ceil()
            let titleTextSize = composable.title.text.size(width: availableWidth - (composable.imageSize.width + composable.imageSpacing)).ceil()
            return CGSize(
                width: spec.containerSize.width,
                height: composable.edgeInsets.top + max(imageSize.height, titleTextSize.height) + composable.edgeInsets.bottom
            )
        case .vertical:
            let imageSize = composable.imageSize.ceil()
            let titleTextSize = composable.title.text.size(width: availableWidth).ceil()
            return CGSize(
                width: composable.edgeInsets.left + max(imageSize.width, titleTextSize.width) + composable.edgeInsets.right,
                height: composable.edgeInsets.top + imageSize.height + composable.imageSpacing + titleTextSize.height + composable.edgeInsets.bottom
            )
        }
    }
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)

        self.imageView = QImageView(frame: self.contentView.bounds)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self.imageView)

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self.titleLabel)
    }
    
    open override func prepare(composable: Composable, spec: IQContainerSpec, animated: Bool) {
        super.prepare(composable: composable, spec: spec, animated: animated)

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
            var selfConstraints: [NSLayoutConstraint] = []
            switch composable.direction {
            case .horizontal:
                selfConstraints.append(self.imageView.topLayout == self.contentView.topLayout + edgeInsets.top)
                selfConstraints.append(self.imageView.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
                selfConstraints.append(self.imageView.trailingLayout == self.titleLabel.leadingLayout - composable.imageSpacing)
                selfConstraints.append(self.imageView.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
                selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top)
                selfConstraints.append(self.titleLabel.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
                selfConstraints.append(self.titleLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            case .vertical:
                selfConstraints.append(self.imageView.topLayout == self.contentView.topLayout + edgeInsets.top)
                selfConstraints.append(self.imageView.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
                selfConstraints.append(self.imageView.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
                selfConstraints.append(self.imageView.bottomLayout == self.titleLabel.topLayout - edgeInsets.bottom)
                selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
                selfConstraints.append(self.titleLabel.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
                selfConstraints.append(self.titleLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            }
            self.selfConstraints = selfConstraints
        }
        if changedDirection == true || changedImageSize == true {
            var imageConstraints: [NSLayoutConstraint] = []
            switch composable.direction {
            case .horizontal:
                imageConstraints.append(self.imageView.widthLayout == composable.imageSize.width)
            case .vertical:
                imageConstraints.append(self.imageView.widthLayout == composable.imageSize.width)
                imageConstraints.append(self.imageView.heightLayout == composable.imageSize.height)
            }
            self.imageConstraints = imageConstraints
        }
        composable.image.apply(target: self.imageView)
        composable.title.apply(target: self.titleLabel)
    }

}
