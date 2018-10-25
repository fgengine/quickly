//
//  Quickly
//

open class QTitleDetailShapeComposable : QComposable {

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var detail: QLabelStyleSheet

    public var shape: IQShapeModel
    public var shapeWidth: CGFloat
    public var shapeSpacing: CGFloat

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        title: QLabelStyleSheet,
        titleSpacing: CGFloat = 4,
        detail: QLabelStyleSheet,
        shape: IQShapeModel,
        shapeWidth: CGFloat = 16,
        shapeSpacing: CGFloat = 4
    ) {
        self.title = title
        self.titleSpacing = titleSpacing
        self.detail = detail
        self.shape = shape
        self.shapeWidth = shapeWidth
        self.shapeSpacing = shapeSpacing
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleDetailShapeComposition< Composable: QTitleDetailShapeComposable > : QComposition< Composable > {

    lazy private var titleLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        view.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(view)
        return view
    }()
    lazy private var detailLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
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
    private var currentTitleSpacing: CGFloat?
    private var currentShapeWidth: CGFloat?
    private var currentShapeSpacing: CGFloat?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    private var shapeConstraints: [NSLayoutConstraint] = [] {
        willSet { self.shapeView.removeConstraints(self.shapeConstraints) }
        didSet { self.shapeView.addConstraints(self.shapeConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerAvailableSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let titleTextSize = composable.title.text.size(width: availableWidth - (composable.shapeWidth + composable.shapeSpacing))
        let detailTextSize = composable.detail.text.size(width: availableWidth - (composable.shapeWidth + composable.shapeSpacing))
        let shapeSize = composable.shape.size
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(titleTextSize.height + composable.titleSpacing + detailTextSize.height, shapeSize.height) + composable.edgeInsets.bottom
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
                self.titleLabel.bottomLayout <= self.detailLabel.topLayout - composable.titleSpacing,
                self.detailLabel.leadingLayout == self.contentView.leadingLayout + edgeInsets.left,
                self.detailLabel.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom,
                self.shapeView.topLayout == self.contentView.topLayout + edgeInsets.top,
                self.shapeView.leadingLayout == self.titleLabel.trailingLayout + composable.shapeSpacing,
                self.shapeView.leadingLayout == self.detailLabel.trailingLayout + composable.shapeSpacing,
                self.shapeView.trailingLayout == self.contentView.trailingLayout - edgeInsets.right,
                self.shapeView.bottomLayout == self.contentView.bottomLayout - edgeInsets.bottom
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
        composable.detail.apply(self.detailLabel)
        self.shapeView.model = composable.shape
    }

}
