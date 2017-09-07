//
//  Quickly
//

import UIKit

open class QSeparatorCollectionCell< ItemType: QSeparatorCollectionItem >: QBackgroundColorCollectionCell< ItemType > {

    internal var separator: QView!
    internal var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(item: ItemType, size: CGSize) -> CGSize {
        let separatorSize: CGFloat = (1 / UIScreen.main.scale)
        switch item.axis {
        case .horizontal: return CGSize(
            width: item.edgeInsets.left + separatorSize + item.edgeInsets.right,
            height: size.height
        )
        case .vertical: return CGSize(
            width: size.width,
            height: item.edgeInsets.top + separatorSize + item.edgeInsets.bottom
        )
        }
    }

    open override func setup() {
        super.setup()

        self.separator = QView(frame: self.contentView.bounds)
        self.separator.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.separator)
    }

    open override func set(item: ItemType) {
        super.set(item: item)
        self.apply(item: item)
    }

    open override func update(item: ItemType) {
        super.update(item: item)
        self.apply(item: item)
    }

    private func apply(item: QSeparatorCollectionItem) {
        self.selfConstraints = [
            self.separator.topLayout == self.contentView.topLayout + item.edgeInsets.top,
            self.separator.leadingLayout == self.contentView.leadingLayout + item.edgeInsets.left,
            self.separator.trailingLayout == self.contentView.trailingLayout - item.edgeInsets.right,
            self.separator.bottomLayout == self.contentView.bottomLayout - item.edgeInsets.bottom
        ]

        self.separator.backgroundColor = item.color
    }
    
}

