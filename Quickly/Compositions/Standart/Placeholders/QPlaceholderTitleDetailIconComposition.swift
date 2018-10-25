//
//  Quickly
//

open class QPlaceholderTitleDetailIconComposable : QComposable {
    
    public var title: QPlaceholderViewStyleSheet
    public var titleHeight: CGFloat
    public var titleSpacing: CGFloat
    
    public var detail: QPlaceholderViewStyleSheet
    public var detailHeight: CGFloat
    
    public var icon: QImageViewStyleSheet
    public var iconWidth: CGFloat
    public var iconSpacing: CGFloat
    
    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        title: QPlaceholderViewStyleSheet,
        titleHeight: CGFloat,
        titleSpacing: CGFloat = 4,
        detail: QPlaceholderViewStyleSheet,
        detailHeight: CGFloat,
        icon: QImageViewStyleSheet,
        iconWidth: CGFloat = 16,
        iconSpacing: CGFloat = 4
    ) {
        self.title = title
        self.titleHeight = titleHeight
        self.titleSpacing = titleSpacing
        self.detail = detail
        self.detailHeight = detailHeight
        self.icon = icon
        self.iconWidth = iconWidth
        self.iconSpacing = iconSpacing
        super.init(edgeInsets: edgeInsets)
    }
    
}

open class QPlaceholderTitleDetailIconComposition< Composable: QPlaceholderTitleDetailIconComposable > : QComposition< Composable > {
    
    lazy private var titleLabel: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    lazy private var detailLabel: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    lazy private var iconView: QImageView = {
        let view = QImageView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    
    private var currentEdgeInsets: UIEdgeInsets?
    private var currentTitleHeight: CGFloat?
    private var currentTitleSpacing: CGFloat?
    private var currentDetailHeight: CGFloat?
    private var currentIconWidth: CGFloat?
    private var currentIconSpacing: CGFloat?
    
    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    private var titleConstraints: [NSLayoutConstraint] = [] {
        willSet { self.titleLabel.removeConstraints(self.titleConstraints) }
        didSet { self.titleLabel.addConstraints(self.titleConstraints) }
    }
    private var detailConstraints: [NSLayoutConstraint] = [] {
        willSet { self.detailLabel.removeConstraints(self.detailConstraints) }
        didSet { self.detailLabel.addConstraints(self.detailConstraints) }
    }
    private var iconConstraints: [NSLayoutConstraint] = [] {
        willSet { self.iconView.removeConstraints(self.iconConstraints) }
        didSet { self.iconView.addConstraints(self.iconConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerAvailableSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let iconSize = composable.icon.source.size(CGSize(width: composable.iconWidth, height: availableWidth))
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(composable.titleHeight + composable.titleSpacing + composable.detailHeight, iconSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets || self.currentTitleSpacing != composable.titleSpacing || self.currentIconSpacing != composable.iconSpacing {
            self.currentEdgeInsets = edgeInsets
            self.currentTitleSpacing = composable.titleSpacing
            self.currentIconSpacing = composable.iconSpacing
            self.selfConstraints = [
                self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.titleLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.titleLabel.bottomLayout <= self.detailLabel.topLayout - composable.titleSpacing,
                self.detailLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.detailLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom,
                self.iconView.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.iconView.leadingLayout == self.titleLabel.trailingLayout + composable.iconSpacing,
                self.iconView.leadingLayout == self.detailLabel.trailingLayout + composable.iconSpacing,
                self.iconView.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.iconView.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom
            ]
        }
        if self.currentTitleHeight != composable.titleHeight {
            self.currentTitleHeight = composable.titleHeight
            self.titleConstraints = [
                self.titleLabel.heightLayout == composable.titleHeight
            ]
        }
        if self.currentDetailHeight != composable.detailHeight {
            self.currentDetailHeight = composable.detailHeight
            self.detailConstraints = [
                self.detailLabel.heightLayout == composable.detailHeight
            ]
        }
        if self.currentIconWidth != composable.iconWidth {
            self.currentIconWidth = composable.iconWidth
            self.iconConstraints = [
                self.iconView.widthLayout == composable.iconWidth
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        composable.title.apply(self.titleLabel)
        composable.detail.apply(self.detailLabel)
        composable.icon.apply(self.iconView)
    }
    
}
