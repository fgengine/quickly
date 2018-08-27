//
//  Quickly
//

open class QImageTitleValueComposable : QComposable {

    public var image: QImageViewStyleSheet
    public var imageWidth: CGFloat
    public var imageSpacing: CGFloat

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var value: QLabelStyleSheet

    public init(
        edgeInsets: UIEdgeInsets = QComposable.defaultEdgeInsets,
        image: QImageViewStyleSheet,
        imageWidth: CGFloat = 96,
        imageSpacing: CGFloat = 4,
        title: QLabelStyleSheet,
        titleSpacing: CGFloat = 4,
        value: QLabelStyleSheet
    ) {
        self.image = image
        self.imageWidth = imageWidth
        self.imageSpacing = imageSpacing
        self.title = title
        self.titleSpacing = titleSpacing
        self.value = value
        super.init(edgeInsets: edgeInsets)
    }

}

open class QImageTitleValueComposition< Composable: QImageTitleValueComposable > : QComposition< Composable > {

    public private(set) var imageView: QImageView!
    public private(set) var titleLabel: QLabel!
    public private(set) var valueLabel: QLabel!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentImageSpacing: CGFloat?
    private var currentTitleSpacing: CGFloat?
    private var currentImageWidth: CGFloat?

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
        let imageSize = composable.image.source.size(CGSize(width: composable.imageWidth, height: availableWidth))
        let valueTextSize = composable.title.text.size(width: availableWidth - (composable.imageWidth + composable.imageSpacing))
        let titleTextSize = composable.value.text.size(width: availableWidth - (composable.imageWidth + composable.imageSpacing + valueTextSize.width + composable.titleSpacing))
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(imageSize.height, titleTextSize.height, valueTextSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)

        self.imageView = QImageView(frame: self.contentView.bounds)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .horizontal)
        self.imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .vertical)
        self.contentView.addSubview(self.imageView)

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self.titleLabel)

        self.valueLabel = QLabel(frame: self.contentView.bounds)
        self.valueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.valueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.valueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self.valueLabel)
    }
    
    open override func prepare(composable: Composable, spec: IQContainerSpec, animated: Bool) {
        super.prepare(composable: composable, spec: spec, animated: animated)
        
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets || self.currentImageSpacing != composable.imageSpacing || self.currentTitleSpacing != composable.titleSpacing {
            self.currentEdgeInsets = edgeInsets
            self.currentImageSpacing = composable.imageSpacing
            self.currentTitleSpacing = composable.titleSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.imageView.topLayout == self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.imageView.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.imageView.trailingLayout == self.titleLabel.leadingLayout - composable.imageSpacing)
            selfConstraints.append(self.imageView.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.titleLabel.trailingLayout == self.valueLabel.leadingLayout - composable.titleSpacing)
            selfConstraints.append(self.titleLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            selfConstraints.append(self.valueLabel.topLayout == self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.valueLabel.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            selfConstraints.append(self.valueLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        if self.currentImageWidth != composable.imageWidth {
            self.currentImageWidth = composable.imageWidth

            var imageConstraints: [NSLayoutConstraint] = []
            imageConstraints.append(self.imageView.widthLayout == composable.imageWidth)
            self.imageConstraints = imageConstraints
        }
        composable.image.apply(target: self.imageView)
        composable.title.apply(target: self.titleLabel)
        composable.value.apply(target: self.valueLabel)
    }

}
