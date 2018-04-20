//
//  Quickly
//

open class QLabelCollectionCell< ItemType: QLabelCollectionItem >: QBackgroundColorCollectionCell< ItemType > {

    private var _label: QLabel!

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
        let textSize = item.label.text.size(width: availableWidth)
        return CGSize(
            width: size.width,
            height: item.edgeInsets.top + textSize.height + item.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self._label = self.prepareLabel()
        self._label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self._label)
    }

    open func prepareLabel() -> QLabel {
        return QLabel(frame: self.contentView.bounds)
    }

    open override func set(item: ItemType, animated: Bool) {
        super.set(item: item, animated: animated)
        
        if self.currentEdgeInsets != item.edgeInsets {
            self.currentEdgeInsets = item.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self._label.topLayout == self.contentView.topLayout + item.edgeInsets.top)
            selfConstraints.append(self._label.leadingLayout == self.contentView.leadingLayout + item.edgeInsets.left)
            selfConstraints.append(self._label.trailingLayout == self.contentView.trailingLayout - item.edgeInsets.right)
            selfConstraints.append(self._label.bottomLayout == self.contentView.bottomLayout - item.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        item.label.apply(target: self._label)
    }

}
