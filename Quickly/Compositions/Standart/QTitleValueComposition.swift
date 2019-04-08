//
//  Quickly
//

open class QTitleValueComposable : QComposable {

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var value: QLabelStyleSheet

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        title: QLabelStyleSheet,
        titleSpacing: CGFloat = 4,
        value: QLabelStyleSheet
    ) {
        self.title = title
        self.titleSpacing = titleSpacing
        self.value = value
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleValueComposition< Composable: QTitleValueComposable > : QComposition< Composable > {

    private lazy var titleLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var valueLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(
            horizontal: UILayoutPriority(rawValue: 252),
            vertical: UILayoutPriority(rawValue: 252)
        )
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
        let valueTextSize = composable.value.size(width: availableWidth)
        let titleTextSize = composable.title.size(width: availableWidth - (valueTextSize.width + composable.titleSpacing))
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(titleTextSize.height, valueTextSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._titleSpacing != composable.titleSpacing {
            self._edgeInsets = composable.edgeInsets
            self._titleSpacing = composable.titleSpacing
            self._constraints = [
                self.titleLabel.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleLabel.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.titleLabel.trailingLayout == self.valueLabel.leadingLayout.offset(-composable.titleSpacing),
                self.titleLabel.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.valueLabel.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.valueLabel.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.valueLabel.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleLabel.apply(composable.title)
        self.valueLabel.apply(composable.value)
    }

}
