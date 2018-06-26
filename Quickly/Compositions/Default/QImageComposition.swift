//
//  Quickly
//

open class QImageComposable : QComposable {

    public var image: QImageViewStyleSheet

    public init(
        image: QImageViewStyleSheet
    ) {
        self.image = image
        super.init()
    }

}

open class QImageComposition< Composable: QImageComposable > : QComposition< Composable > {

    public private(set) var imageView: QImageView!

    private var currentEdgeInsets: UIEdgeInsets?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(composable: Composable, size: CGSize) -> CGSize {
        let availableWidth = size.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let imageSize = composable.image.source.size(CGSize(width: availableWidth, height: availableWidth))
        return CGSize(
            width: size.width,
            height: composable.edgeInsets.top + imageSize.height + composable.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.imageView = QImageView(frame: self.contentView.bounds)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.imageView)
    }

    open override func prepare(composable: Composable, animated: Bool) {
        super.prepare(composable: composable, animated: animated)

        if self.currentEdgeInsets != composable.edgeInsets {
            self.currentEdgeInsets = composable.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.imageView.topLayout == self.contentView.topLayout + composable.edgeInsets.top)
            selfConstraints.append(self.imageView.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left)
            selfConstraints.append(self.imageView.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right)
            selfConstraints.append(self.imageView.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        composable.image.apply(target: self.imageView)
    }

}
