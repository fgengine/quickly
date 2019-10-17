//
//  Quickly
//

open class QTitleDetailComposable : QComposable {

    public var titleStyle: QLabelStyleSheet
    public var titleSpacing: CGFloat
    public var detailStyle: QLabelStyleSheet

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        titleStyle: QLabelStyleSheet,
        titleSpacing: CGFloat = 4,
        detailStyle: QLabelStyleSheet
    ) {
        self.titleStyle = titleStyle
        self.titleSpacing = titleSpacing
        self.detailStyle = detailStyle
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleDetailComposition< Composable: QTitleDetailComposable > : QComposition< Composable > {

    public private(set) lazy var titleView: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(
            horizontal: UILayoutPriority(rawValue: 252),
            vertical: UILayoutPriority(rawValue: 252)
        )
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var detailView: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()

    private var _edgeInsets: UIEdgeInsets?
    private var _titleSpacing: CGFloat?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let titleTextSize = composable.titleStyle.size(width: availableWidth)
        let detailTextSize = composable.detailStyle.size(width: availableWidth)
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + titleTextSize.height + composable.titleSpacing + detailTextSize.height + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._titleSpacing != composable.titleSpacing {
            self._edgeInsets = composable.edgeInsets
            self._titleSpacing = composable.titleSpacing
            self._constraints = [
                self.titleView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.titleView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.titleView.bottomLayout <= self.detailView.topLayout.offset(-composable.titleSpacing),
                self.detailView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.detailView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.detailView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets .bottom)
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleView.apply(composable.titleStyle)
        self.detailView.apply(composable.detailStyle)
    }

}
