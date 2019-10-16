//
//  Quickly
//

open class QTitleDetailShapeComposable : QComposable {

    public private(set) var titleStyle: QLabelStyleSheet
    public private(set) var titleSpacing: CGFloat

    public private(set) var detailStyle: QLabelStyleSheet

    public private(set) var shapeModel: QShapeView.Model
    public private(set) var shapeWidth: CGFloat
    public private(set) var shapeSpacing: CGFloat

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        titleStyle: QLabelStyleSheet,
        titleSpacing: CGFloat = 4,
        detailStyle: QLabelStyleSheet,
        shapeModel: QShapeView.Model,
        shapeWidth: CGFloat = 16,
        shapeSpacing: CGFloat = 4
    ) {
        self.titleStyle = titleStyle
        self.titleSpacing = titleSpacing
        self.detailStyle = detailStyle
        self.shapeModel = shapeModel
        self.shapeWidth = shapeWidth
        self.shapeSpacing = shapeSpacing
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleDetailShapeComposition< Composable: QTitleDetailShapeComposable > : QComposition< Composable > {

    public private(set) lazy var titleView: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(
            horizontal: UILayoutPriority(rawValue: 252),
            vertical: UILayoutPriority(rawValue: 252)
        )
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var detailView: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    public private(set) lazy var shapeView: QShapeView = {
        let view = QShapeView(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    
    private var _edgeInsets: UIEdgeInsets?
    private var _titleSpacing: CGFloat?
    private var _shapeWidth: CGFloat?
    private var _shapeSpacing: CGFloat?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }
    private var _shapeConstraints: [NSLayoutConstraint] = [] {
        willSet { self.shapeView.removeConstraints(self._shapeConstraints) }
        didSet { self.shapeView.addConstraints(self._shapeConstraints) }
    }
    
    open override class func size(composable: Composable, spec: IQContainerSpec) -> CGSize {
        let availableWidth = spec.containerSize.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let titleTextSize = composable.titleStyle.size(width: availableWidth - (composable.shapeWidth + composable.shapeSpacing))
        let detailTextSize = composable.detailStyle.size(width: availableWidth - (composable.shapeWidth + composable.shapeSpacing))
        let shapeSize = composable.shapeModel.size
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(titleTextSize.height + composable.titleSpacing + detailTextSize.height, shapeSize.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._titleSpacing != composable.titleSpacing || self._shapeSpacing != composable.shapeSpacing {
            self._edgeInsets = composable.edgeInsets
            self._titleSpacing = composable.titleSpacing
            self._shapeSpacing = composable.shapeSpacing
            self._constraints = [
                self.titleView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.titleView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.titleView.bottomLayout <= self.detailView.topLayout.offset(-composable.titleSpacing),
                self.detailView.leadingLayout == self.contentView.leadingLayout.offset(composable.edgeInsets.left),
                self.detailView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom),
                self.shapeView.topLayout == self.contentView.topLayout.offset(composable.edgeInsets.top),
                self.shapeView.leadingLayout == self.titleView.trailingLayout.offset(composable.shapeSpacing),
                self.shapeView.leadingLayout == self.detailView.trailingLayout.offset(composable.shapeSpacing),
                self.shapeView.trailingLayout == self.contentView.trailingLayout.offset(-composable.edgeInsets.right),
                self.shapeView.bottomLayout == self.contentView.bottomLayout.offset(-composable.edgeInsets.bottom)
            ]
        }
        if self._shapeWidth != composable.shapeWidth {
            self._shapeWidth = composable.shapeWidth
            self._shapeConstraints = [
                self.shapeView.widthLayout == composable.shapeWidth
            ]
        }
    }
    
    open override func apply(composable: Composable, spec: IQContainerSpec) {
        self.titleView.apply(composable.titleStyle)
        self.detailView.apply(composable.detailStyle)
        self.shapeView.model = composable.shapeModel
    }

}
