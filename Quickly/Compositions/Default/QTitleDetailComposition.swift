//
//  Quickly
//

open class QTitleDetailComposable : QComposable {

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat
    public var detail: QLabelStyleSheet

    public init(
        edgeInsets: UIEdgeInsets = QComposable.defaultEdgeInsets,
        title: QLabelStyleSheet,
        titleSpacing: CGFloat = 4,
        detail: QLabelStyleSheet
    ) {
        self.title = title
        self.titleSpacing = titleSpacing
        self.detail = detail
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleDetailComposition< Composable: QTitleDetailComposable >: QComposition< Composable > {

    public private(set) var titleLabel: QLabel!
    public private(set) var detailLabel: QLabel!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentTitleSpacing: CGFloat?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerAvailableSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let titleTextSize = composable.title.text.size(width: availableWidth)
        let detailTextSize = composable.detail.text.size(width: availableWidth)
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + ceil(titleTextSize.height) + composable.titleSpacing + ceil(detailTextSize.height) + composable.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self.titleLabel)

        self.detailLabel = QLabel(frame: self.contentView.bounds)
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.detailLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self.detailLabel)
    }
    
    open override func prepare(composable: Composable, spec: IQContainerSpec, animated: Bool) {
        super.prepare(composable: composable, spec: spec, animated: animated)
        
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftEdgeInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightEdgeInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets || self.currentTitleSpacing != composable.titleSpacing {
            self.currentEdgeInsets = edgeInsets
            self.currentTitleSpacing = composable.titleSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.titleLabel.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            selfConstraints.append(self.titleLabel.bottomLayout <= self.detailLabel.topLayout - composable.titleSpacing)
            selfConstraints.append(self.detailLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.detailLabel.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            selfConstraints.append(self.detailLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        composable.title.apply(target: self.titleLabel)
        composable.detail.apply(target: self.detailLabel)
    }

}
