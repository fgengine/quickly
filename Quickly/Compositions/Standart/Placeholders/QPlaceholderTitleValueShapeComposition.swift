//
//  Quickly
//

open class QPlaceholderTitleValueShapeComposable : QComposable {
    
    public var title: QPlaceholderViewStyleSheet
    public var titleHeight: CGFloat
    public var titleSpacing: CGFloat
    
    public var value: QPlaceholderViewStyleSheet
    public var valueHeight: CGFloat
    
    public var shape: IQShapeModel
    public var shapeWidth: CGFloat
    public var shapeSpacing: CGFloat
    
    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        title: QPlaceholderViewStyleSheet,
        titleHeight: CGFloat,
        titleSpacing: CGFloat = 4,
        value: QPlaceholderViewStyleSheet,
        valueHeight: CGFloat,
        shape: IQShapeModel,
        shapeWidth: CGFloat = 16,
        shapeSpacing: CGFloat = 4
    ) {
        self.title = title
        self.titleHeight = titleHeight
        self.titleSpacing = titleSpacing
        self.value = value
        self.valueHeight = valueHeight
        self.shape = shape
        self.shapeWidth = shapeWidth
        self.shapeSpacing = shapeSpacing
        super.init(edgeInsets: edgeInsets)
    }
    
}

open class QPlaceholderTitleValueShapeComposition< Composable: QPlaceholderTitleValueShapeComposable > : QComposition< Composable > {
    
    lazy private var titleLabel: QPlaceholderView = {
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
    lazy private var shapeView: QShapeView = {
        let view = QShapeView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    
    private var currentEdgeInsets: UIEdgeInsets?
    private var currentTitleHeight: CGFloat?
    private var currentTitleSpacing: CGFloat?
    private var currentValueHeight: CGFloat?
    private var currentShapeWidth: CGFloat?
    private var currentShapeSpacing: CGFloat?
    
    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    private var titleConstraints: [NSLayoutConstraint] = [] {
        willSet { self.titleLabel.removeConstraints(self.titleConstraints) }
        didSet { self.titleLabel.addConstraints(self.titleConstraints) }
    }
    private var valueConstraints: [NSLayoutConstraint] = [] {
        willSet { self.valueLabel.removeConstraints(self.valueConstraints) }
        didSet { self.valueLabel.addConstraints(self.valueConstraints) }
    }
    private var shapeConstraints: [NSLayoutConstraint] = [] {
        willSet { self.shapeView.removeConstraints(self.shapeConstraints) }
        didSet { self.shapeView.addConstraints(self.shapeConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let shapeSzie = composable.shape.size
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(composable.titleHeight, composable.valueHeight, shapeSzie.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        let edgeInsets = UIEdgeInsets(
            top: composable.edgeInsets.top,
            left: spec.containerLeftInset + composable.edgeInsets.left,
            bottom: composable.edgeInsets.bottom,
            right: spec.containerRightInset + composable.edgeInsets.right
        )
        if self.currentEdgeInsets != edgeInsets || self.currentTitleSpacing != composable.titleSpacing || self.currentShapeSpacing != composable.shapeSpacing {
            self.currentEdgeInsets = edgeInsets
            self.currentTitleSpacing = composable.titleSpacing
            self.currentShapeSpacing = composable.shapeSpacing
            self.selfConstraints = [
                self.titleLabel.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.titleLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.titleLabel.trailingLayout == self.valueLabel.leadingLayout - composable.titleSpacing,
                self.titleLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom,
                self.valueLabel.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.valueLabel.trailingLayout == self.shapeView.leadingLayout - composable.shapeSpacing,
                self.valueLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom,
                self.shapeView.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.shapeView.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.shapeView.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom
            ]
        }
        if self.currentTitleHeight != composable.titleHeight {
            self.currentTitleHeight = composable.titleHeight
            self.titleConstraints = [
                self.titleLabel.heightLayout == composable.titleHeight
            ]
        }
        if self.currentValueHeight != composable.valueHeight {
            self.currentValueHeight = composable.valueHeight
            self.valueConstraints = [
                self.valueLabel.heightLayout == composable.valueHeight
            ]
        }
        if self.currentShapeWidth != composable.shapeWidth {
            self.currentShapeWidth = composable.shapeWidth
            self.shapeConstraints = [
                self.shapeView.widthLayout == composable.shapeWidth
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        composable.title.apply(self.titleLabel)
        composable.value.apply(self.valueLabel)
        self.shapeView.model = composable.shape
    }
    
}
