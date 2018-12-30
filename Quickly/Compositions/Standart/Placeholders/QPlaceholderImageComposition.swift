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

    private lazy var imageView: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()

    private var _edgeInsets: UIEdgeInsets?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
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
        if self._edgeInsets != edgeInsets {
            self._edgeInsets = edgeInsets
            self._constraints = [
                self.imageView.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.imageView.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.imageView.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.imageView.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.imageView.apply(composable.image)
    }

}
