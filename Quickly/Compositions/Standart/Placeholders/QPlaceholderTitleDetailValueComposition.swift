//
//  Quickly
//

open class QPlaceholderTitleDetailValueComposable : QComposable {
    
    public var title: QPlaceholderViewStyleSheet
    public var titleHeight: CGFloat
    public var titleSpacing: CGFloat
    
    public var detail: QPlaceholderViewStyleSheet
    public var detailHeight: CGFloat
    
    public var value: QPlaceholderViewStyleSheet
    public var valueSize: CGSize
    public var valueSpacing: CGFloat
    
    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        title: QPlaceholderViewStyleSheet,
        titleHeight: CGFloat,
        titleSpacing: CGFloat = 4,
        detail: QPlaceholderViewStyleSheet,
        detailHeight: CGFloat,
        value: QPlaceholderViewStyleSheet,
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
    lazy private var valueLabel: QPlaceholderView = {
        let view = QPlaceholderView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    
    private var currentEdgeInsets: UIEdgeInsets?
    private var currentTitleHeight: CGFloat?
    private var currentTitleSpacing: CGFloat?
    private var currentDetailHeight: CGFloat?
    private var currentValueSize: CGSize?
    private var currentValueSpacing: CGFloat?
    
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
    private var valueConstraints: [NSLayoutConstraint] = [] {
        willSet { self.valueLabel.removeConstraints(self.valueConstraints) }
        didSet { self.valueLabel.addConstraints(self.valueConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(composable.titleHeight + composable.titleSpacing + composable.detailHeight, composable.valueSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets || self.currentTitleSpacing != composable.titleSpacing || self.currentValueSpacing != composable.valueSpacing {
            self.currentEdgeInsets = edgeInsets
            self.currentTitleSpacing = composable.titleSpacing
            self.currentValueSpacing = composable.valueSpacing
            self.selfConstraints = [
                self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.titleLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.titleLabel.trailingLayout == self.valueLabel.leadingLayout - composable.valueSpacing,
                self.titleLabel.bottomLayout <= self.detailLabel.topLayout - composable.titleSpacing,
                self.detailLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.detailLabel.trailingLayout == self.valueLabel.leadingLayout - composable.valueSpacing,
                self.detailLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom,
                self.valueLabel.topLayout >= self.contentView.topLayout + edgeInsets.top,
                self.valueLabel.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.valueLabel.bottomLayout <= self.contentView.bottomLayout - edgeInsets.bottom,
                self.valueLabel.centerYLayout == self.contentView.centerYLayout
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
        if self.currentValueSize != composable.valueSize {
            self.currentValueSize = composable.valueSize
            self.valueConstraints = [
                self.valueLabel.widthLayout == composable.valueSize.width,
                self.valueLabel.heightLayout == composable.valueSize.height
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        composable.title.apply(self.titleLabel)
        composable.detail.apply(self.detailLabel)
        composable.value.apply(self.valueLabel)
    }
    
}
