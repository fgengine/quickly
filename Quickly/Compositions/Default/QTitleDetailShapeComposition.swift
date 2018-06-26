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
        title: QLabelStyleSheet,
        detail: QLabelStyleSheet,
        shape: IQShapeModel
    ) {
        self.title = title
        self.titleSpacing = 4
        self.detail = detail
        self.shape = shape
        self.shapeWidth = 16
        self.shapeSpacing = 8
        super.init()
    }

}

open class QTitleDetailShapeComposition< Composable: QTitleDetailShapeComposable >: QComposition< Composable > {

    public private(set) var titleLabel: QLabel!
    public private(set) var detailLabel: QLabel!
    public private(set) var shapeView: QShapeView!

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

    open override class func size(composable: Composable, size: CGSize) -> CGSize {
        let availableWidth = size.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let titleTextSize = composable.title.text.size(width: availableWidth - (composable.shapeWidth + composable.shapeSpacing))
        let detailTextSize = composable.detail.text.size(width: availableWidth - (composable.shapeWidth + composable.shapeSpacing))
        return CGSize(
            width: size.width,
            height: composable.edgeInsets.top + max(titleTextSize.height + composable.titleSpacing + detailTextSize.height, composable.shape.size.height) + composable.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .vertical)
        self.contentView.addSubview(self.titleLabel)

        self.detailLabel = QLabel(frame: self.contentView.bounds)
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.detailLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self.detailLabel)

        self.shapeView = QShapeView(frame: self.contentView.bounds)
        self.shapeView.translatesAutoresizingMaskIntoConstraints = false
        self.shapeView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.shapeView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self.shapeView)
}

    open override func prepare(composable: Composable, animated: Bool) {
        super.prepare(composable: composable, animated: animated)
        
        if self.currentEdgeInsets != composable.edgeInsets || self.currentTitleSpacing != composable.titleSpacing || self.currentShapeSpacing != composable.shapeSpacing {
            self.currentEdgeInsets = composable.edgeInsets
            self.currentTitleSpacing = composable.titleSpacing
            self.currentShapeSpacing = composable.shapeSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + composable.edgeInsets.top)
            selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left)
            selfConstraints.append(self.titleLabel.bottomLayout == self.detailLabel.topLayout - composable.titleSpacing)
            selfConstraints.append(self.detailLabel.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left)
            selfConstraints.append(self.detailLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom)
            selfConstraints.append(self.shapeView.topLayout == self.contentView.topLayout + composable.edgeInsets.top)
            selfConstraints.append(self.shapeView.leadingLayout == self.titleLabel.trailingLayout + composable.shapeSpacing)
            selfConstraints.append(self.shapeView.leadingLayout == self.detailLabel.trailingLayout + composable.shapeSpacing)
            selfConstraints.append(self.shapeView.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right)
            selfConstraints.append(self.shapeView.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        if self.currentShapeWidth != composable.shapeWidth {
            self.currentShapeWidth = composable.shapeWidth

            var shapeConstraints: [NSLayoutConstraint] = []
            shapeConstraints.append(self.shapeView.widthLayout == composable.shapeWidth)
            self.shapeConstraints = shapeConstraints
        }
        composable.title.apply(target: self.titleLabel)
        composable.detail.apply(target: self.detailLabel)
        self.shapeView.model = composable.shape
    }

}
