//
//  Quickly
//

import UIKit

open class QImageLabelTableCell< RowType: QImageLabelTableRow >: QBackgroundColorTableCell< RowType > {

    internal var pictureView: QImageView!
    internal var label: QLabel!
    internal var currentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.currentConstraints) }
        didSet { self.contentView.addConstraints(self.currentConstraints) }
    }

    open override class func height(row: RowType, width: CGFloat) -> CGFloat {
        guard let imageSource: QImageSource = row.imageSource, let text: IQText = row.text else {
            return 0
        }
        let availableWidth: CGFloat = width - (row.edgeInsets.left + row.edgeInsets.right)
        let imageSize: CGSize = imageSource.size(available: CGSize(
            width: row.imageWidth, height: availableWidth
        ))
        let textSize: CGSize = text.size(width: availableWidth - (imageSize.width + row.spacing))
        return row.edgeInsets.top + max(imageSize.height, textSize.height) + row.edgeInsets.bottom
    }

    open override func setup() {
        super.setup()

        self.pictureView = QImageView(frame: self.contentView.bounds)
        self.pictureView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.pictureView)

        self.label = QLabel(frame: self.contentView.bounds)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.label)
    }

    open override func set(row: RowType) {
        super.set(row: row)
        self.apply(row: row)
    }

    open override func update(row: RowType) {
        super.update(row: row)
        self.apply(row: row)
    }

    private func apply(row: QImageLabelTableRow) {
        self.currentConstraints = [
            self.pictureView.topLayout == self.contentView.topLayout + row.edgeInsets.top,
            self.pictureView.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left,
            self.pictureView.trailingLayout == self.label.leadingLayout - row.spacing,
            self.pictureView.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom,

            self.label.topLayout == self.contentView.topLayout + row.edgeInsets.top,
            self.label.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right,
            self.label.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom
        ]

        self.pictureView.roundCorners = row.imageRoundCorners
        self.pictureView.source = row.imageSource

        self.label.contentAlignment = row.textContentAlignment
        self.label.padding = row.textPadding
        self.label.numberOfLines = row.textNumberOfLines
        self.label.lineBreakMode = row.textLineBreakMode
        self.label.text = row.text
    }

}

