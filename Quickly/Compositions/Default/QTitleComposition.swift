//
//  Quickly
//

open class QTitleCompositionData : QCompositionData {

    public var title: QLabelStyleSheet

    public init(
        title: QLabelStyleSheet
    ) {
        self.title = title
        super.init()
    }

}

public class QTitleComposition< DataType: QTitleCompositionData > : QComposition< DataType > {

    public private(set) var titleLabel: QLabel!

    private var currentEdgeInsets: UIEdgeInsets?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(data: DataType?, size: CGSize) -> CGSize {
        guard let data = data else { return CGSize.zero }
        let availableWidth = size.width - (data.edgeInsets.left + data.edgeInsets.right)
        let textSize = data.title.text.size(width: availableWidth)
        return CGSize(
            width: size.width,
            height: data.edgeInsets.top + textSize.height + data.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.titleLabel)
    }

    open override func prepare(data: DataType, animated: Bool) {
        if self.currentEdgeInsets != data.edgeInsets {
            self.currentEdgeInsets = data.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.titleLabel.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
            selfConstraints.append(self.titleLabel.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        data.title.apply(target: self.titleLabel)
    }

}
