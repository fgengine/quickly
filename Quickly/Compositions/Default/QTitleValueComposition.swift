//
//  Quickly
//

open class QTitleValueCompositionData : QCompositionData {

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

public class QTitleValueComposition< DataType: QTitleValueCompositionData >: QComposition< DataType > {

    public private(set) var titleLabel: QLabel!
    public private(set) var valueLabel: QLabel!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentTitleSpacing: CGFloat?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(data: DataType?, size: CGSize) -> CGSize {
        guard let data = data else { return CGSize.zero }
        let availableWidth = size.width - (data.edgeInsets.left + data.edgeInsets.right)
        let valueTextSize = data.value.text.size(width: availableWidth)
        let titleTextSize = data.title.text.size(width: availableWidth - (valueTextSize.width + data.titleSpacing))
        return CGSize(
            width: size.width,
            height: data.edgeInsets.top + max(titleTextSize.height, valueTextSize.height) + data.edgeInsets.bottom
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

    open override func prepare(data: DataType, animated: Bool) {
        if self.currentEdgeInsets != data.edgeInsets || self.currentTitleSpacing != data.titleSpacing {
            self.currentEdgeInsets = data.edgeInsets
            self.currentTitleSpacing = data.titleSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.titleLabel.trailingLayout == self.valueLabel.leadingLayout - data.titleSpacing)
            selfConstraints.append(self.titleLabel.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            selfConstraints.append(self.valueLabel.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.valueLabel.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
            selfConstraints.append(self.valueLabel.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        data.title.apply(target: self.titleLabel)
        data.value.apply(target: self.valueLabel)
    }

}
