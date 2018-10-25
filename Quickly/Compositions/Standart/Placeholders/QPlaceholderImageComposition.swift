//
//  Quickly
//

open class QPlaceholderImageComposable : QComposable {

    public var image: QPlaceholderViewStyleSheet
    public var imageHeight: CGFloat

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        image: QPlaceholderViewStyleSheet,
        imageHeight: CGFloat
    ) {
        self.image = image
        self.imageHeight = imageHeight
        super.init(edgeInsets: edgeInsets)
    }

}

open class QPlaceholderImageComposition< Composable: QPlaceholderImageComposable > : QComposition< Composable > {

    lazy private var imageView: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
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
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + composable.imageHeight + composable.edgeInsets.bottom
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
