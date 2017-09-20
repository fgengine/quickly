//
//  Quickly
//

import UIKit

open class QLabelCollectionCell< ItemType: QLabelCollectionItem >: QBackgroundColorCollectionCell< ItemType > {

    internal var label: QLabel!
    internal var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(
        item: ItemType,
        layout: UICollectionViewLayout,
        section: IQCollectionSection,
        size: CGSize
    ) -> CGSize {
        guard let text: IQText = item.text else {
            return CGSize.zero
        }
        let availableWidth: CGFloat = size.width - (item.edgeInsets.left + item.edgeInsets.right)
        let textSize: CGSize = text.size(width: availableWidth)
        return CGSize(
            width: size.width,
            height: item.edgeInsets.top + textSize.height + item.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.label = QLabel(frame: self.contentView.bounds)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.label)
    }

    open override func set(item: ItemType) {
        super.set(item: item)
        self.apply(item: item)
    }

    open override func update(item: ItemType) {
        super.update(item: item)
        self.apply(item: item)
    }

    private func apply(item: QLabelCollectionItem) {
        var selfConstraints: [NSLayoutConstraint] = []
        selfConstraints.append(self.label.topLayout == self.contentView.topLayout + item.edgeInsets.top)
        selfConstraints.append(self.label.leadingLayout == self.contentView.leadingLayout + item.edgeInsets.left)
        selfConstraints.append(self.label.trailingLayout == self.contentView.trailingLayout - item.edgeInsets.right)
        selfConstraints.append(self.label.bottomLayout == self.contentView.bottomLayout - item.edgeInsets.bottom)
        self.selfConstraints = selfConstraints

        self.label.contentAlignment = item.contentAlignment
        self.label.padding = item.padding
        self.label.numberOfLines = item.numberOfLines
        self.label.lineBreakMode = item.lineBreakMode
        self.label.text = item.text
    }

}

