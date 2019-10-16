//
//  Quickly
//

open class QTitleDetailValueComposable : QComposable {

    public private(set) var titleStyle: QLabelStyleSheet
    public private(set) var titleSpacing: CGFloat

    public private(set) var detailStyle: QLabelStyleSheet

    public private(set) var valueStyle: QLabelStyleSheet
    public private(set) var valueSpacing: CGFloat

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        titleStyle: QLabelStyleSheet,
        titleSpacing: CGFloat = 4,
        detailStyle: QLabelStyleSheet,
        valueStyle: QLabelStyleSheet,
        valueSpacing: CGFloat = 4
    ) {
        self.titleStyle = titleStyle
        self.titleSpacing = titleSpacing
        self.detailStyle = detailStyle
        self.valueStyle = valueStyle
        self.valueSpacing = valueSpacing
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleDetailValueComposition< Composable: QTitleDetailValueComposable > : QComposition< Composable > {

    public private(set) lazy var titleView: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var detailView: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var valueView: QLabel = {
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
    private var _valueSpacing: CGFloat?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let valueTextSize = composable.valueStyle.size(width: availableWidth - composable.valueSpacing)
        let titleTextSize = composable.titleStyle.size(width: availableWidth - (valueTextSize.width + composable.valueSpacing))
        let detailTextSize = composable.detailStyle.size(width: availableWidth - (valueTextSize.width + composable.valueSpacing))
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(titleTextSize.height + composable.titleSpacing + detailTextSize.height, valueTextSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._titleSpacing != composable.titleSpacing || self._valueSpacing != composable.valueSpacing {
            self._edgeInsets = composable.edgeInsets
            self._titleSpacing = composable.titleSpacing
            self._valueSpacing = composable.valueSpacing
            self._constraints = [
                self.titleView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.titleView.trailingLayout == self.valueView.leadingLayout.offset(-composable.valueSpacing),
                self.titleView.bottomLayout <= self.detailView.topLayout.offset(-composable.titleSpacing),
                self.detailView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.detailView.trailingLayout == self.valueView.leadingLayout.offset(-composable.valueSpacing),
                self.detailView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.valueView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.valueView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.valueView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleView.apply(composable.titleStyle)
        self.detailView.apply(composable.detailStyle)
        self.valueView.apply(composable.valueStyle)
    }

}
