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

    lazy private var titleLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
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
        let textSize = composable.title.text.size(width: availableWidth)
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + textSize.height + composable.edgeInsets.bottom
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
                self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.titleLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.titleLabel.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.titleLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        composable.title.apply(self.titleLabel)
    }

}
