//
//  Quickly
//

open class QImageComposable : QComposable {

    public var image: QImageViewStyleSheet

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        image: QImageViewStyleSheet
    ) {
        self.image = image
        super.init(edgeInsets: edgeInsets)
    }

}

open class QImageComposition< Composable: QImageComposable > : QComposition< Composable > {

    lazy private var imageView: QImageView = {
        let view = QImageView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()

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
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets {
            self.currentEdgeInsets = edgeInsets
            self.selfConstraints = [
                self.imageView.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.imageView.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.imageView.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.imageView.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        composable.image.apply(self.imageView)
    }

}
