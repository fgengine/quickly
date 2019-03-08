//
//  Quickly
//

open class QPlaceholderTitleComposable : QComposable {
    
    public var title: QPlaceholderStyleSheet
    public var titleHeight: CGFloat
    
    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        title: QPlaceholderStyleSheet,
        titleHeight: CGFloat
    ) {
        self.title = title
        self.titleHeight = titleHeight
        super.init(edgeInsets: edgeInsets)
    }
    
}

open class QPlaceholderTitleComposition< Composable: QPlaceholderTitleComposable > : QComposition< Composable > {
    
    private lazy var titleLabel: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    
    private var _edgeInsets: UIEdgeInsets?
    private var _titleHeight: CGFloat?
    
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    private var _titleConstraints: [NSLayoutConstraint] = [] {
        willSet { self.titleLabel.removeConstraints(self._titleConstraints) }
        didSet { self.titleLabel.addConstraints(self._titleConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + composable.titleHeight + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets {
            self._edgeInsets = composable.edgeInsets
            self._constraints = [
                self.titleLabel.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                self.titleLabel.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left,
                self.titleLabel.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right,
                self.titleLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom
            ]
        }
        if self._titleHeight != composable.titleHeight {
            self._titleHeight = composable.titleHeight
            self._titleConstraints = [
                self.titleLabel.heightLayout == composable.titleHeight
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleLabel.apply(composable.title)
    }
    
}
