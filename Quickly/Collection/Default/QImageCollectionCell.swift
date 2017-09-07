//
//  Quickly
//

import UIKit

open class QImageCollectionCell< ItemType: QImageCollectionItem >: QBackgroundColorCollectionCell< ItemType > {

    internal var pictureView: QImageView!
    internal var currentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.currentConstraints) }
        didSet { self.contentView.addConstraints(self.currentConstraints) }
    }

    open override class func size(item: ItemType, size: CGSize) -> CGSize {
        guard let source: QImageSource = item.source else {
            return CGSize.zero
        }
        let availableWidth: CGFloat = size.width - (item.edgeInsets.left + item.edgeInsets.right)
        let imageSize: CGSize = source.size(available: CGSize(
            width: availableWidth, height: availableWidth
        ))
        return CGSize(
            width: size.width,
            height: item.edgeInsets.top + imageSize.height + item.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.pictureView = QImageView(frame: self.contentView.bounds)
        self.pictureView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.pictureView)
    }

    open override func set(item: ItemType) {
        super.set(item: item)
        self.apply(item: item)
    }

    open override func update(item: ItemType) {
        super.update(item: item)
        self.apply(item: item)
    }

    private func apply(item: QImageCollectionItem) {
        self.currentConstraints = [
            self.pictureView.topLayout == self.contentView.topLayout + item.edgeInsets.top,
            self.pictureView.leadingLayout == self.contentView.leadingLayout + item.edgeInsets.left,
            self.pictureView.trailingLayout == self.contentView.trailingLayout - item.edgeInsets.right,
            self.pictureView.bottomLayout == self.contentView.bottomLayout - item.edgeInsets.bottom
        ]

        self.pictureView.roundCorners = item.roundCorners
        self.pictureView.source = item.source
    }

}

