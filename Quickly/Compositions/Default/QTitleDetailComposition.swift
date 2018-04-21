//
//  Quickly
//

open class QTitleDetailCompositionData : QCompositionData {

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat
    public var detail: QLabelStyleSheet

    public init(
        title: QLabelStyleSheet,
        detail: QLabelStyleSheet
    ) {
        self.title = title
        self.titleSpacing = 4
        self.detail = detail
        super.init()
    }

}

open class QTitleDetailComposition< DataType: QTitleDetailCompositionData >: QComposition< DataType > {

    public private(set) var titleLabel: QLabel!
    public private(set) var detailLabel: QLabel!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentTitleSpacing: CGFloat?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(data: DataType, size: CGSize) -> CGSize {
        let availableWidth = size.width - (data.edgeInsets.left + data.edgeInsets.right)
        let titleTextSize = data.title.text.size(width: availableWidth)
        let detailTextSize = data.detail.text.size(width: availableWidth)
        return CGSize(
            width: size.width,
            height: data.edgeInsets.top + titleTextSize.height + data.titleSpacing + detailTextSize.height + data.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self.titleLabel)

        self.detailLabel = QLabel(frame: self.contentView.bounds)
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.detailLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self.detailLabel)
    }

    open override func prepare(data: DataType, animated: Bool) {
        super.prepare(data: data, animated: animated)
        
        if self.currentEdgeInsets != data.edgeInsets || self.currentTitleSpacing != data.titleSpacing {
            self.currentEdgeInsets = data.edgeInsets
            self.currentTitleSpacing = data.titleSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.titleLabel.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
            selfConstraints.append(self.titleLabel.bottomLayout == self.detailLabel.topLayout - data.titleSpacing)
            selfConstraints.append(self.detailLabel.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.detailLabel.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
            selfConstraints.append(self.detailLabel.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        data.title.apply(target: self.titleLabel)
        data.detail.apply(target: self.detailLabel)
    }

}
