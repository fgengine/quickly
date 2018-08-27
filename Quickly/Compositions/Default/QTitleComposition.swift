//
//  Quickly
//

open class QTitleComposable : QComposable {

    public var title: QLabelStyleSheet

    public init(
        edgeInsets: UIEdgeInsets = QComposable.defaultEdgeInsets,
        title: QLabelStyleSheet
    ) {
        self.title = title
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleComposition< Composable: QTitleComposable > : QComposition< Composable > {

    public private(set) var titleLabel: QLabel!

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
    
    open override func setup(owner: AnyObject) {
        super.setup(owner: owner)

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.titleLabel)
    }
    
    open override func prepare(composable: Composable, spec: IQContainerSpec, animated: Bool) {
        super.prepare(composable: composable, spec: spec, animated: animated)
        
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets {
            self.currentEdgeInsets = edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.titleLabel.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            selfConstraints.append(self.titleLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        composable.title.apply(target: self.titleLabel)
    }

}
