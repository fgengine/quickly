//
//  Quickly
//

open class QTitleValueComposable : QComposable {

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var value: QLabelStyleSheet

    public init(
        title: QLabelStyleSheet,
        value: QLabelStyleSheet
    ) {
        self.title = title
        self.titleSpacing = 8
        self.value = value
        super.init()
    }

}

open class QTitleValueComposition< Composable: QTitleValueComposable > : QComposition< Composable > {

    public private(set) var titleLabel: QLabel!
    public private(set) var valueLabel: QLabel!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentTitleSpacing: CGFloat?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(composable: Composable, size: CGSize) -> CGSize {
        let availableWidth = size.width - (composable.edgeInsets.left + composable.edgeInsets.right)
        let valueTextSize = composable.value.text.size(width: availableWidth)
        let titleTextSize = composable.title.text.size(width: availableWidth - (valueTextSize.width + composable.titleSpacing))
        return CGSize(
            width: size.width,
            height: composable.edgeInsets.top + max(titleTextSize.height, valueTextSize.height) + composable.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self.titleLabel)

        self.valueLabel = QLabel(frame: self.contentView.bounds)
        self.valueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.valueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.valueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self.valueLabel)
    }

    open override func prepare(composable: Composable, animated: Bool) {
        super.prepare(composable: composable, animated: animated)
        
        if self.currentEdgeInsets != composable.edgeInsets || self.currentTitleSpacing != composable.titleSpacing {
            self.currentEdgeInsets = composable.edgeInsets
            self.currentTitleSpacing = composable.titleSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + composable.edgeInsets.top)
            selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + composable.edgeInsets.left)
            selfConstraints.append(self.titleLabel.trailingLayout == self.valueLabel.leadingLayout - composable.titleSpacing)
            selfConstraints.append(self.titleLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom)
            selfConstraints.append(self.valueLabel.topLayout == self.contentView.topLayout + composable.edgeInsets.top)
            selfConstraints.append(self.valueLabel.trailingLayout == self.contentView.trailingLayout - composable.edgeInsets.right)
            selfConstraints.append(self.valueLabel.bottomLayout == self.contentView.bottomLayout - composable.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        composable.title.apply(target: self.titleLabel)
        composable.value.apply(target: self.valueLabel)
    }

}
