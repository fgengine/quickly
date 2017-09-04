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
        let imageRect: CGRect = source.rect(bounds: CGRect(
            x: 0, y: 0, width: availableWidth, height: availableWidth
        ))
        return row.edgeInsets.top + imageRect.integral.height + row.edgeInsets.bottom
    }

    open override func setup() {
        super.setup()

        self.pictureView = QImageView(frame: self.contentView.bounds)
        self.pictureView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.pictureView)
    }

    open override func set(row: RowType) {
        super.set(row: row)
        self.apply(imageRow: row)
    }

    open override func update(row: RowType) {
        super.update(row: row)
        self.apply(imageRow: row)
    }

    private func apply(imageRow: QImageTableRow) {
        self.currentConstraints = [
            self.pictureView.topLayout == self.contentView.topLayout + imageRow.edgeInsets.top,
            self.pictureView.leadingLayout == self.contentView.leadingLayout + imageRow.edgeInsets.left,
            self.pictureView.trailingLayout == self.contentView.trailingLayout - imageRow.edgeInsets.right,
            self.pictureView.bottomLayout == self.contentView.bottomLayout - imageRow.edgeInsets.bottom
        ]

        self.pictureView.roundCorners = imageRow.roundCorners
        self.pictureView.source = imageRow.source
    }

}

