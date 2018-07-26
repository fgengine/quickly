//
//  Quickly
//

open class QTitleDetailIconComposable : QComposable {

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var detail: QLabelStyleSheet

    public var icon: QImageViewStyleSheet
    public var iconWidth: CGFloat
    public var iconSpacing: CGFloat

    public init(
        edgeInsets: UIEdgeInsets = QComposable.defaultEdgeInsets,
        title: QLabelStyleSheet,
        titleSpacing: CGFloat = 4,
        detail: QLabelStyleSheet,
        icon: QImageViewStyleSheet,
        iconWidth: CGFloat = 16,
        iconSpacing: CGFloat = 4
    ) {
        self.title = title
        self.titleSpacing = titleSpacing
        self.detail = detail
        self.icon = icon
        self.iconWidth = iconWidth
        self.iconSpacing = iconSpacing
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleDetailIconComposition< Composable: QTitleDetailIconComposable >: QComposition< Composable > {

    public private(set) var titleLabel: QLabel!
    public private(set) var detailLabel: QLabel!
    public private(set) var iconView: QImageView!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentTitleSpacing: CGFloat?
    private var currentImageWidth: CGFloat?
    private var currentImageSpacing: CGFloat?

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
        let titleTextSize = composable.title.text.size(width: availableWidth - (composable.iconWidth + composable.iconSpacing))
        let detailTextSize = composable.detail.text.size(width: availableWidth - (composable.iconWidth + composable.iconSpacing))
        let iconSize = composable.icon.source.size(CGSize(width: composable.iconWidth, height: availableWidth))
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(ceil(titleTextSize.height) + composable.titleSpacing + ceil(detailTextSize.height), iconSize.height) + composable.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .vertical)
        self.contentView.addSubview(self.titleLabel)

        self.detailLabel = QLabel(frame: self.contentView.bounds)
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.detailLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self.detailLabel)

        self.iconView = QImageView(frame: self.contentView.bounds)
        self.iconView.translatesAutoresizingMaskIntoConstraints = false
        self.iconView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.iconView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
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
        if self.currentEdgeInsets != edgeInsets || self.currentTitleSpacing != composable.titleSpacing || self.currentImageSpacing != composable.iconSpacing {
            self.currentEdgeInsets = edgeInsets
            self.currentTitleSpacing = composable.titleSpacing
            self.currentImageSpacing = composable.iconSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.titleLabel.bottomLayout <= self.detailLabel.topLayout - composable.titleSpacing)
            selfConstraints.append(self.detailLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left)
            selfConstraints.append(self.detailLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            selfConstraints.append(self.iconView.topLayout == self.contentView.topLayout + edgeInsets.top)
            selfConstraints.append(self.iconView.leadingLayout == self.titleLabel.trailingLayout + composable.iconSpacing)
            selfConstraints.append(self.iconView.leadingLayout == self.detailLabel.trailingLayout + composable.iconSpacing)
            selfConstraints.append(self.iconView.trailingLayout == self.contentView.trailingLayout - edgeInsets.right)
            selfConstraints.append(self.iconView.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        if self.currentImageWidth != composable.iconWidth {
            self.currentImageWidth = composable.iconWidth

            var iconConstraints: [NSLayoutConstraint] = []
            iconConstraints.append(self.iconView.widthLayout == composable.iconWidth)
            self.iconConstraints = iconConstraints
        }
        composable.title.apply(target: self.titleLabel)
        composable.detail.apply(target: self.detailLabel)
        composable.icon.apply(target: self.iconView)
    }

}
