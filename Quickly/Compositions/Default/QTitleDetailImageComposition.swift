//
//  Quickly
//

open class QTitleDetailImageComposable : QComposable {

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var detail: QLabelStyleSheet

    public var image: QImageViewStyleSheet
    public var imageWidth: CGFloat
    public var imageSpacing: CGFloat

    public init(
        title: QLabelStyleSheet,
        detail: QLabelStyleSheet,
        image: QImageViewStyleSheet
    ) {
        self.title = title
        self.titleSpacing = 4
        self.detail = detail
        self.image = image
        self.imageWidth = 16
        self.imageSpacing = 8
        super.init()
    }

}

open class QTitleDetailImageComposition< Composable: QTitleDetailImageComposable >: QComposition< Composable > {

    public private(set) var titleLabel: QLabel!
    public private(set) var detailLabel: QLabel!
    public private(set) var imageView: QImageView!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentTitleSpacing: CGFloat?
    private var currentImageWidth: CGFloat?
    private var currentImageSpacing: CGFloat?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    private var imageConstraints: [NSLayoutConstraint] = [] {
        willSet { self.imageView.removeConstraints(self.imageConstraints) }
        didSet { self.imageView.addConstraints(self.imageConstraints) }
    }

    open override class func size(composable: Composable, size: CGSize) -> CGSize {
        let availableWidth = size.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let titleTextSize = composable.title.text.size(width: availableWidth - (composable.imageWidth + composable.imageSpacing))
        let detailTextSize = composable.detail.text.size(width: availableWidth - (composable.imageWidth + composable.imageSpacing))
        let imageSize = composable.image.source.size(CGSize(width: composable.imageWidth, height: availableWidth))
        return CGSize(
            width: size.width,
            height: composable.edgeInsets.top + max(titleTextSize.height + composable.titleSpacing + detailTextSize.height, imageSize.height) + composable.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .vertical)
        self.contentView.addSubview(self.titleLabel)

        self.detailLabel = QLabel(frame: self.contentView.bounds)
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.detailLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self.detailLabel)

        self.imageView = QImageView(frame: self.contentView.bounds)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self.imageView)
}

    open override func prepare(composable: Composable, animated: Bool) {
        super.prepare(composable: composable, animated: animated)
        
        if self.currentEdgeInsets != composable.edgeInsets || self.currentTitleSpacing != composable.titleSpacing || self.currentImageSpacing != composable.imageSpacing {
            self.currentEdgeInsets = composable.edgeInsets
            self.currentTitleSpacing = composable.titleSpacing
            self.currentImageSpacing = composable.imageSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + composable.edgeInsets.top)
            selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left)
            selfConstraints.append(self.titleLabel.bottomLayout == self.detailLabel.topLayout - composable.titleSpacing)
            selfConstraints.append(self.detailLabel.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left)
            selfConstraints.append(self.detailLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom)
            selfConstraints.append(self.imageView.topLayout == self.contentView.topLayout + composable.edgeInsets.top)
            selfConstraints.append(self.imageView.leadingLayout == self.titleLabel.trailingLayout + composable.imageSpacing)
            selfConstraints.append(self.imageView.leadingLayout == self.detailLabel.trailingLayout + composable.imageSpacing)
            selfConstraints.append(self.imageView.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right)
            selfConstraints.append(self.imageView.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        if self.currentImageWidth != composable.imageWidth {
            self.currentImageWidth = composable.imageWidth

            var imageConstraints: [NSLayoutConstraint] = []
            imageConstraints.append(self.imageView.widthLayout == composable.imageWidth)
            self.imageConstraints = imageConstraints
        }
        composable.title.apply(target: self.titleLabel)
        composable.detail.apply(target: self.detailLabel)
        composable.image.apply(target: self.imageView)
    }

}
