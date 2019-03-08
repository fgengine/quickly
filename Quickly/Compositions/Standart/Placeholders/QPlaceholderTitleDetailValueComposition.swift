//
//  Quickly
//

open class QPlaceholderTitleDetailValueComposable : QComposable {
    
    public var title: QPlaceholderStyleSheet
    public var titleHeight: CGFloat
    public var titleSpacing: CGFloat
    
    public var detail: QPlaceholderStyleSheet
    public var detailHeight: CGFloat
    
    public var value: QPlaceholderStyleSheet
    public var valueSize: CGSize
    public var valueSpacing: CGFloat
    
    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        title: QPlaceholderStyleSheet,
        titleHeight: CGFloat,
        titleSpacing: CGFloat = 4,
        detail: QPlaceholderStyleSheet,
        detailHeight: CGFloat,
        value: QPlaceholderStyleSheet,
        valueSize: CGSize,
        valueSpacing: CGFloat = 4
    ) {
        self.title = title
        self.titleHeight = titleHeight
        self.titleSpacing = titleSpacing
        self.detail = detail
        self.detailHeight = detailHeight
        self.value = value
        self.valueSize = valueSize
        self.valueSpacing = valueSpacing
        super.init(edgeInsets: edgeInsets)
    }
    
}

open class QPlaceholderTitleDetailValueComposition< Composable: QPlaceholderTitleDetailValueComposable > : QComposition< Composable > {
    
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
    private lazy var valueLabel: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    
    private var _edgeInsets: UIEdgeInsets?
    private var _titleHeight: CGFloat?
    private var _titleSpacing: CGFloat?
    private var _detailHeight: CGFloat?
    private var _valueSize: CGSize?
    private var _valueSpacing: CGFloat?
    
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
    private var _valueConstraints: [NSLayoutConstraint] = [] {
        willSet { self.valueLabel.removeConstraints(self._valueConstraints) }
        didSet { self.valueLabel.addConstraints(self._valueConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(composable.titleHeight + composable.titleSpacing + composable.detailHeight, composable.valueSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._titleSpacing != composable.titleSpacing || self._valueSpacing != composable.valueSpacing {
            self._edgeInsets = composable.edgeInsets
            self._titleSpacing = composable.titleSpacing
            self._valueSpacing = composable.valueSpacing
            self._constraints = [
                self.titleLabel.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                self.titleLabel.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left,
                self.titleLabel.trailingLayout == self.valueLabel.leadingLayout - composable.valueSpacing,
                self.titleLabel.bottomLayout <= self.detailLabel.topLayout - composable.titleSpacing,
                self.detailLabel.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left,
                self.detailLabel.trailingLayout == self.valueLabel.leadingLayout - composable.valueSpacing,
                self.detailLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom,
                self.valueLabel.topLayout >= self.contentView.topLayout + composable.edgeInsets.top,
                self.valueLabel.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right,
                self.valueLabel.bottomLayout <= self.contentView.bottomLayout - composable.edgeInsets.bottom,
                self.valueLabel.centerYLayout == self.contentView.centerYLayout
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
        if self._valueSize != composable.valueSize {
            self._valueSize = composable.valueSize
            self._valueConstraints = [
                self.valueLabel.widthLayout == composable.valueSize.width,
                self.valueLabel.heightLayout == composable.valueSize.height
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleLabel.apply(composable.title)
        self.detailLabel.apply(composable.detail)
        self.valueLabel.apply(composable.value)
    }
    
}
