//
//  Quickly
//

open class QSeparatorCollectionItem : QBackgroundColorCollectionItem {

    public var edgeInsets: UIEdgeInsets
    public var axis: UILayoutConstraintAxis
    public var color: UIColor

    public init(axis: UILayoutConstraintAxis, color: UIColor) {
        self.edgeInsets = UIEdgeInsets.zero
        self.axis = axis
        self.color = color
        super.init()
    }

}

open class QSeparatorCollectionCell< ItemType: QSeparatorCollectionItem >: QBackgroundColorCollectionCell< ItemType > {

    private var _separator: QView!

    private var currentEdgeInsets: UIEdgeInsets?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(
        item: ItemType,
        layout: UICollectionViewLayout,
        section: IQCollectionSection,
        size: CGSize
    ) -> CGSize {
        let separatorSize = (1 / UIScreen.main.scale)
        switch item.axis {
        case .horizontal:
            return CGSize(
                width: item.edgeInsets.left + separatorSize + item.edgeInsets.right,
                height: size.height
            )
        case .vertical:
            return CGSize(
                width: size.width,
                height: item.edgeInsets.top + separatorSize + item.edgeInsets.bottom
            )
        }
    }

    open override func setup() {
        super.setup()

        self._separator = self.prepareView()
        self._separator.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self._separator)
    }

    open func prepareView() -> QView {
        return QView(frame: self.contentView.bounds)
    }

    open override func set(item: ItemType, animated: Bool) {
        super.set(item: item, animated: animated)

        if self.currentEdgeInsets != item.edgeInsets {
            self.currentEdgeInsets = item.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self._separator.topLayout == self.contentView.topLayout + item.edgeInsets.top)
            selfConstraints.append(self._separator.leadingLayout == self.contentView.leadingLayout + item.edgeInsets.left)
            selfConstraints.append(self._separator.trailingLayout == self.contentView.trailingLayout - item.edgeInsets.right)
            selfConstraints.append(self._separator.bottomLayout == self.contentView.bottomLayout - item.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        self._separator.backgroundColor = item.color
    }

}
