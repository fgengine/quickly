//
//  Quickly
//

open class QTitleValueIconComposable : QComposable {

    public var titleStyle: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var valueStyle: QLabelStyleSheet

    public var iconStyle: QImageViewStyleSheet
    public var iconWidth: CGFloat
    public var iconSpacing: CGFloat

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        titleStyle: QLabelStyleSheet,
        titleSpacing: CGFloat = 4,
        valueStyle: QLabelStyleSheet,
        iconStyle: QImageViewStyleSheet,
        iconWidth: CGFloat = 16,
        iconSpacing: CGFloat = 4
    ) {
        self.titleStyle = titleStyle
        self.titleSpacing = titleSpacing
        self.valueStyle = valueStyle
        self.iconStyle = iconStyle
        self.iconWidth = iconWidth
        self.iconSpacing = iconSpacing
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleValueIconComposition< Composable: QTitleValueIconComposable > : QComposition< Composable > {

    public private(set) lazy var titleView: QLabel = {
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
    public private(set) lazy var iconView: QImageView = {
        let view = QImageView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()

    private var _edgeInsets: UIEdgeInsets?
    private var _titleSpacing: CGFloat?
    private var _iconWidth: CGFloat?
    private var _iconSpacing: CGFloat?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    private var _iconConstraints: [NSLayoutConstraint] = [] {
        willSet { self.iconView.removeConstraints(self._iconConstraints) }
        didSet { self.iconView.addConstraints(self._iconConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let valueTextSize = composable.valueStyle.size(width: availableWidth - (composable.iconWidth + composable.iconSpacing))
        let titleTextSize = composable.titleStyle.size(width: availableWidth - (valueTextSize.width + composable.titleSpacing + composable.iconWidth + composable.iconSpacing))
        let iconSize = composable.iconStyle.size(CGSize(width: composable.iconWidth, height: availableWidth))
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(titleTextSize.height, valueTextSize.height, iconSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._titleSpacing != composable.titleSpacing || self._iconSpacing != composable.iconSpacing {
            self._edgeInsets = composable.edgeInsets
            self._titleSpacing = composable.titleSpacing
            self._iconSpacing = composable.iconSpacing
            self._constraints = [
                self.titleView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.titleView.trailingLayout == self.valueView.leadingLayout.offset(-composable.titleSpacing),
                self.titleView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.valueView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.valueView.trailingLayout == self.iconView.leadingLayout.offset(-composable.iconSpacing),
                self.valueView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.iconView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.iconView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.iconView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
            ]
        }
        if self._iconWidth != composable.iconWidth {
            self._iconWidth = composable.iconWidth
            self._iconConstraints = [
                self.iconView.widthLayout == composable.iconWidth
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleView.apply(composable.titleStyle)
        self.valueView.apply(composable.valueStyle)
        self.iconView.apply(composable.iconStyle)
    }

}
