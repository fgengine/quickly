//
//  Quickly
//

open class QTitleValueIconComposable : QComposable {

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var value: QLabelStyleSheet

    public var icon: QImageViewStyleSheet
    public var iconWidth: CGFloat
    public var iconSpacing: CGFloat

    public init(
        edgeInsets: UIEdgeInsets = QComposable.defaultEdgeInsets,
        title: QLabelStyleSheet,
        titleSpacing: CGFloat = 4,
        value: QLabelStyleSheet,
        icon: QImageViewStyleSheet,
        iconWidth: CGFloat = 16,
        iconSpacing: CGFloat = 4
    ) {
        self.title = title
        self.titleSpacing = titleSpacing
        self.value = value
        self.icon = icon
        self.iconWidth = iconWidth
        self.iconSpacing = iconSpacing
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleValueIconComposition< Composable: QTitleValueIconComposable >: QComposition< Composable > {

    public private(set) var titleLabel: QLabel!
    public private(set) var valueLabel: QLabel!
    public private(set) var iconView: QImageView!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentTitleSpacing: CGFloat?
    private var currentIconWidth: CGFloat?
    private var currentIconSpacing: CGFloat?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    private var iconConstraints: [NSLayoutConstraint] = [] {
        willSet { self.iconView.removeConstraints(self.iconConstraints) }
        didSet { self.iconView.addConstraints(self.iconConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerAvailableSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let valueTextSize = composable.value.text.size(width: availableWidth - (composable.iconWidth + composable.iconSpacing))
        let titleTextSize = composable.title.text.size(width: availableWidth - (valueTextSize.width + composable.titleSpacing + composable.iconWidth + composable.iconSpacing))
        let iconSize = composable.icon.source.size(CGSize(width: composable.iconWidth, height: availableWidth))
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(titleTextSize.height, valueTextSize.height, iconSize.height) + composable.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self.titleLabel)

        self.valueLabel = QLabel(frame: self.contentView.bounds)
        self.valueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.valueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.valueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self.valueLabel)

        self.iconView = QImageView(frame: self.contentView.bounds)
        self.iconView.translatesAutoresizingMaskIntoConstraints = false
        self.iconView.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .horizontal)
        self.iconView.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .vertical)
        self.contentView.addSubview(self.iconView)
    }
    
    open override func prepare(composable: Composable, spec: IQContainerSpec, animated: Bool) {
        super.prepare(composable: composable, spec: spec, animated: animated)
        
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftEdgeInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightEdgeInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets || self.currentTitleSpacing != composable.titleSpacing || self.currentIconSpacing != composable.iconSpacing {
            self.currentEdgeInsets = edgeInsets
            self.currentTitleSpacing = composable.titleSpacing
            self.currentIconSpacing = composable.iconSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.titleLabel.trailingLayout == self.valueLabel.leadingLayout - composable.titleSpacing)
            selfConstraints.append(self.titleLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            selfConstraints.append(self.valueLabel.topLayout == self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.valueLabel.trailingLayout == self.iconView.leadingLayout - composable.iconSpacing)
            selfConstraints.append(self.valueLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            selfConstraints.append(self.iconView.topLayout == self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.iconView.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            selfConstraints.append(self.iconView.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        if self.currentIconWidth != composable.iconWidth {
            self.currentIconWidth = composable.iconWidth

            var iconConstraints: [NSLayoutConstraint] = []
            iconConstraints.append(self.iconView.widthLayout == composable.iconWidth)
            self.iconConstraints = iconConstraints
        }
        composable.title.apply(target: self.titleLabel)
        composable.value.apply(target: self.valueLabel)
        composable.icon.apply(target: self.iconView)
    }

}
