//
//  Quickly
//

open class QImageComposable : QComposable {

    public var image: QImageViewStyleSheet

    public init(
        edgeInsets: UIEdgeInsets = QComposable.defaultEdgeInsets,
        image: QImageViewStyleSheet
    ) {
        self.image = image
        super.init(edgeInsets: edgeInsets)
    }

}

open class QImageComposition< Composable: QImageComposable > : QComposition< Composable > {

    public private(set) var imageView: QImageView!

    private var currentEdgeInsets: UIEdgeInsets?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerAvailableSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let imageSize = composable.image.source.size(CGSize(width: availableWidth, height: availableWidth))
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + imageSize.height + composable.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.imageView = QImageView(frame: self.contentView.bounds)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.imageView)
    }
    
    open override func prepare(composable: Composable, spec: IQContainerSpec, animated: Bool) {
        super.prepare(composable: composable, spec: spec, animated: animated)

        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftEdgeInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightEdgeInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets {
            self.currentEdgeInsets = edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.imageView.topLayout == self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.imageView.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.imageView.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            selfConstraints.append(self.imageView.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        composable.image.apply(target: self.imageView)
    }

}
