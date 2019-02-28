//
//  Quickly
//

open class QTitleComposable : QComposable {

    public var title: QLabelStyleSheet

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        title: QLabelStyleSheet
    ) {
        self.title = title
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleComposition< Composable: QTitleComposable > : QComposition< Composable > {

    private lazy var titleLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
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
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let textSize = composable.title.text.size(width: availableWidth)
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + textSize.height + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets {
            self._edgeInsets = composable.edgeInsets
            self._constraints = [
                self.titleLabel.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                self.titleLabel.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left,
                self.titleLabel.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right,
                self.titleLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleLabel.apply(composable.title)
    }

}
