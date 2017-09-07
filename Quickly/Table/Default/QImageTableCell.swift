//
//  Quickly
//

import UIKit

open class QImageTableCell< RowType: QImageTableRow >: QBackgroundColorTableCell< RowType > {

    internal var pictureView: QImageView!
    internal var currentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.currentConstraints) }
        didSet { self.contentView.addConstraints(self.currentConstraints) }
    }

    open override class func height(row: RowType, width: CGFloat) -> CGFloat {
        guard let source: QImageSource = row.source else {
            return 0
        }
        let availableWidth: CGFloat = width - (row.edgeInsets.left + row.edgeInsets.right)
        let imageSize: CGSize = source.size(available: CGSize(
            width: availableWidth, height: availableWidth
        ))
        return row.edgeInsets.top + imageSize.height + row.edgeInsets.bottom
    }

    open override func setup() {
        super.setup()

        self.pictureView = QImageView(frame: self.contentView.bounds)
        self.pictureView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.pictureView)
    }

    open override func set(row: RowType) {
        super.set(row: row)
        self.apply(row: row)
    }

    open override func update(row: RowType) {
        super.update(row: row)
        self.apply(row: row)
    }

    private func apply(row: QImageTableRow) {
        self.currentConstraints = [
            self.pictureView.topLayout == self.contentView.topLayout + row.edgeInsets.top,
            self.pictureView.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left,
            self.pictureView.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right,
            self.pictureView.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom
        ]

        self.pictureView.roundCorners = row.roundCorners
        self.pictureView.source = row.source
    }

}

