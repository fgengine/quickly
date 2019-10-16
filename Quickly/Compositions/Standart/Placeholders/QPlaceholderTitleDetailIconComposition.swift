//
//  Quickly
//

open class QPlaceholderTitleDetailIconComposable : QComposable {
    
    public private(set) var titleStyle: QPlaceholderStyleSheet
    public private(set) var titleHeight: CGFloat
    public private(set) var titleSpacing: CGFloat
    
    public private(set) var detailStyle: QPlaceholderStyleSheet
    public private(set) var detailHeight: CGFloat
    
    public private(set) var iconStyle: QImageViewStyleSheet
    public private(set) var iconWidth: CGFloat
    public private(set) var iconSpacing: CGFloat
    
    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        titleStyle: QPlaceholderStyleSheet,
        titleHeight: CGFloat,
        titleSpacing: CGFloat = 4,
        detailStyle: QPlaceholderStyleSheet,
        detailHeight: CGFloat,
        iconStyle: QImageViewStyleSheet,
        iconWidth: CGFloat = 16,
        iconSpacing: CGFloat = 4
    ) {
        self.titleStyle = titleStyle
        self.titleHeight = titleHeight
        self.titleSpacing = titleSpacing
        self.detailStyle = detailStyle
        self.detailHeight = detailHeight
        self.iconStyle = iconStyle
        self.iconWidth = iconWidth
        self.iconSpacing = iconSpacing
        super.init(edgeInsets: edgeInsets)
    }
    
}

open class QPlaceholderTitleDetailIconComposition< Composable: QPlaceholderTitleDetailIconComposable > : QComposition< Composable > {
    
    public private(set) lazy var titleView: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var detailView: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
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
    private var _titleHeight: CGFloat?
    private var _titleSpacing: CGFloat?
    private var _detailHeight: CGFloat?
    private var _iconWidth: CGFloat?
    private var _iconSpacing: CGFloat?
    
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    private var _titleConstraints: [NSLayoutConstraint] = [] {
        willSet { self.titleView.removeConstraints(self._titleConstraints) }
        didSet { self.titleView.addConstraints(self._titleConstraints) }
    }
    private var _detailConstraints: [NSLayoutConstraint] = [] {
        willSet { self.detailView.removeConstraints(self._detailConstraints) }
        didSet { self.detailView.addConstraints(self._detailConstraints) }
    }
    private var _iconConstraints: [NSLayoutConstraint] = [] {
        willSet { self.iconView.removeConstraints(self._iconConstraints) }
        didSet { self.iconView.addConstraints(self._iconConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let iconSize = composable.iconStyle.size(CGSize(width: composable.iconWidth, height: availableWidth))
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(composable.titleHeight + composable.titleSpacing + composable.detailHeight, iconSize.height) + composable.edgeInsets.bottom
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
                self.titleView.bottomLayout <= self.detailView.topLayout.offset(-composable.titleSpacing),
                self.detailView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.detailView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.iconView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.iconView.leadingLayout == self.titleView.trailingLayout.offset(composable.iconSpacing),
                self.iconView.leadingLayout == self.detailView.trailingLayout.offset(composable.iconSpacing),
                self.iconView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.iconView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
            ]
        }
        if self._titleHeight != composable.titleHeight {
            self._titleHeight = composable.titleHeight
            self._titleConstraints = [
                self.titleView.heightLayout == composable.titleHeight
            ]
        }
        if self._detailHeight != composable.detailHeight {
            self._detailHeight = composable.detailHeight
            self._detailConstraints = [
                self.detailView.heightLayout == composable.detailHeight
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
        self.detailView.apply(composable.detailStyle)
        self.iconView.apply(composable.iconStyle)
    }
    
}
