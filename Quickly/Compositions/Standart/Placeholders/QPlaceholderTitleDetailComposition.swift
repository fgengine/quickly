//
//  Quickly
//

open class QPlaceholderTitleDetailComposable : QComposable {
    
    public var title: QPlaceholderViewStyleSheet
    public var titleHeight: CGFloat
    public var titleSpacing: CGFloat
    
    public var detail: QPlaceholderViewStyleSheet
    public var detailHeight: CGFloat
    
    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        title: QPlaceholderViewStyleSheet,
        titleHeight: CGFloat,
        titleSpacing: CGFloat = 4,
        detail: QPlaceholderViewStyleSheet,
        detailHeight: CGFloat
    ) {
        self.title = title
        self.titleHeight = titleHeight
        self.titleSpacing = titleSpacing
        self.detail = detail
        self.detailHeight = detailHeight
        super.init(edgeInsets: edgeInsets)
    }
    
}

open class QPlaceholderTitleDetailComposition< Composable: QPlaceholderTitleDetailComposable > : QComposition< Composable > {
    
    private lazy var titleLabel: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var detailLabel: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    
    private var _edgeInsets: UIEdgeInsets?
    private var _titleHeight: CGFloat?
    private var _titleSpacing: CGFloat?
    private var _detailHeight: CGFloat?
    
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    private var _titleConstraints: [NSLayoutConstraint] = [] {
        willSet { self.titleLabel.removeConstraints(self._titleConstraints) }
        didSet { self.titleLabel.addConstraints(self._titleConstraints) }
    }
    private var _detailConstraints: [NSLayoutConstraint] = [] {
        willSet { self.detailLabel.removeConstraints(self._detailConstraints) }
        didSet { self.detailLabel.addConstraints(self._detailConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + composable.titleHeight + composable.titleSpacing + composable.detailHeight + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._titleSpacing != composable.titleSpacing {
            self._edgeInsets = composable.edgeInsets
            self._titleSpacing = composable.titleSpacing
            self._constraints = [
                self.titleLabel.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                self.titleLabel.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left,
                self.titleLabel.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right,
                self.titleLabel.bottomLayout <= self.detailLabel.topLayout - composable.titleSpacing,
                self.detailLabel.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left,
                self.detailLabel.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right,
                self.detailLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom
            ]
        }
        if self._titleHeight != composable.titleHeight {
            self._titleHeight = composable.titleHeight
            self._titleConstraints = [
                self.titleLabel.heightLayout == composable.titleHeight
            ]
        }
        if self._detailHeight != composable.detailHeight {
            self._detailHeight = composable.detailHeight
            self._detailConstraints = [
                self.detailLabel.heightLayout == composable.detailHeight
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleLabel.apply(composable.title)
        self.detailLabel.apply(composable.detail)
    }
    
}
