//
//  Quickly
//

open class QTitleValueShapeComposable : QComposable {

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat = 0

    public var value: QLabelStyleSheet

    public var shape: QShapeView.Model
    public var shapeWidth: CGFloat
    public var shapeSpacing: CGFloat

    public init(
        edgeInsets: UIEdgeInsets = UIEdgeInsets.zero,
        title: QLabelStyleSheet,
        titleSpacing: CGFloat = 4,
        value: QLabelStyleSheet,
        shape: QShapeView.Model,
        shapeWidth: CGFloat = 16,
        shapeSpacing: CGFloat = 4
    ) {
        self.title = title
        self.titleSpacing = titleSpacing
        self.value = value
        self.shape = shape
        self.shapeWidth = shapeWidth
        self.shapeSpacing = shapeSpacing
        super.init(edgeInsets: edgeInsets)
    }

}

open class QTitleValueShapeComposition< Composable: QTitleValueShapeComposable > : QComposition< Composable > {

    private lazy var titleLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var valueLabel: QLabel = {
        let view = QLabel(frame: self.contentView.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(
            horizontal: UILayoutPriority(rawValue: 252),
            vertical: UILayoutPriority(rawValue: 252)
        )
        self.contentView.addSubview(view)
        return view
    }()
    private lazy var shapeView: QShapeView = {
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
        let valueTextSize = composable.value.text.size(width: availableWidth - (composable.shapeWidth + composable.shapeSpacing))
        let titleTextSize = composable.title.text.size(width: availableWidth - (valueTextSize.width + composable.titleSpacing + composable.shapeWidth + composable.shapeSpacing))
        let shapeSzie = composable.shape.size
        return CGSize(
            width: spec.containerSize.width,
            height: composable.edgeInsets.top + max(titleTextSize.height, valueTextSize.height, shapeSzie.height) + composable.edgeInsets.bottom
        )
    }
    
    open override func preLayout(composable: Composable, spec: IQContainerSpec) {
        if self._edgeInsets != composable.edgeInsets || self._titleSpacing != composable.titleSpacing || self._shapeSpacing != composable.shapeSpacing {
            self._edgeInsets = composable.edgeInsets
            self._titleSpacing = composable.titleSpacing
            self._shapeSpacing = composable.shapeSpacing
            self._constraints = [
                self.titleLabel.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                self.titleLabel.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left,
                self.titleLabel.trailingLayout == self.valueLabel.leadingLayout - composable.titleSpacing,
                self.titleLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom,
                self.valueLabel.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                self.valueLabel.trailingLayout == self.shapeView.leadingLayout - composable.shapeSpacing,
                self.valueLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom,
                self.shapeView.topLayout == self.contentView.topLayout + composable.edgeInsets.top,
                self.shapeView.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right,
                self.shapeView.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom
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
        self.titleLabel.apply(composable.title)
        self.valueLabel.apply(composable.value)
        self.shapeView.model = composable.shape
    }

}
