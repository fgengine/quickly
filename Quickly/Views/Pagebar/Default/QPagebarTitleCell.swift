//
//  Quickly
//

open class QPagebarTitleItem : QPagebarItem {

    public var backgroundColor: UIColor?
    public var selectedBackgroundColor: UIColor?
    public var edgeInsets: UIEdgeInsets
    public var title: QLabelStyleSheet

    public init(title: QLabelStyleSheet, backgroundColor: UIColor? = nil, selectedBackgroundColor: UIColor? = nil, edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.edgeInsets = edgeInsets
        super.init()
        self.canSelect = true
        self.canDeselect = true
    }

}

open class QPagebarTitleCell< ItemType: QPagebarTitleItem > : QPagebarCell< ItemType > {

    private var _titleLabel: QLabel!
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
        let availableWidth = size.width - (item.edgeInsets.left + item.edgeInsets.right)
        let textSize = item.title.text.size(width: availableWidth)
        let fitSize = CGSize(
            width: item.edgeInsets.left + textSize.width + item.edgeInsets.right,
            height: item.edgeInsets.top + textSize.height + item.edgeInsets.bottom
        )
        if let flowLayout = layout as? UICollectionViewFlowLayout {
            switch flowLayout.scrollDirection {
            case .horizontal:
                return CGSize(
                    width: textSize.width,
                    height: fitSize.height
                )
            case .vertical:
                return CGSize(
                    width: fitSize.width,
                    height: size.height
                )
            }
        }
        return fitSize
    }

    open override func setup() {
        super.setup()

        self._titleLabel = QLabel(frame: self.contentView.bounds)
        self._titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self._titleLabel)
    }

    open override func set(item: ItemType, animated: Bool) {
        super.set(item: item, animated: animated)

        if let backgroundColor = item.backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let selectedBackgroundColor = item.selectedBackgroundColor {
            let view = UIView(frame: self.bounds)
            view.backgroundColor = selectedBackgroundColor
            self.selectedBackgroundView = view
        } else {
            self.selectedBackgroundView = nil
        }

        if self.currentEdgeInsets != item.edgeInsets {
            self.currentEdgeInsets = item.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self._titleLabel.topLayout == self.contentView.topLayout + item.edgeInsets.top)
            selfConstraints.append(self._titleLabel.leadingLayout == self.contentView.leadingLayout + item.edgeInsets.left)
            selfConstraints.append(self._titleLabel.trailingLayout == self.contentView.trailingLayout - item.edgeInsets.right)
            selfConstraints.append(self._titleLabel.bottomLayout == self.contentView.bottomLayout - item.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        item.title.apply(target: self._titleLabel)
    }

}
