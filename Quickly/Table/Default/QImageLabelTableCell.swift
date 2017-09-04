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
        let imageRect: CGRect = imageSource.rect(bounds: CGRect(
            x: 0, y: 0, width: availableWidth, height: availableWidth
        ))
        let textSize: CGSize = text.size(width: availableWidth)
        return row.edgeInsets.top + max(imageRect.integral.height, textSize.height) + row.edgeInsets.bottom
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
        self.apply(imageLabelRow: row)
    }

    open override func update(row: RowType) {
        super.update(row: row)
        self.apply(imageLabelRow: row)
    }

    private func apply(imageLabelRow: QImageLabelTableRow) {
        self.currentConstraints = [
            self.pictureView.topLayout == self.contentView.topLayout + imageLabelRow.edgeInsets.top,
            self.pictureView.leadingLayout == self.contentView.leadingLayout + imageLabelRow.edgeInsets.left,
            self.pictureView.trailingLayout == self.label.leadingLayout - imageLabelRow.spacing,
            self.pictureView.bottomLayout == self.contentView.bottomLayout - imageLabelRow.edgeInsets.bottom,

            self.label.topLayout == self.contentView.topLayout + imageLabelRow.edgeInsets.top,
            self.label.trailingLayout == self.contentView.trailingLayout - imageLabelRow.edgeInsets.right,
            self.label.bottomLayout == self.contentView.bottomLayout - imageLabelRow.edgeInsets.bottom
        ]

        self.pictureView.roundCorners = imageLabelRow.imageRoundCorners
        self.pictureView.source = imageLabelRow.imageSource

        self.label.contentAlignment = imageLabelRow.textContentAlignment
        self.label.padding = imageLabelRow.textPadding
        self.label.numberOfLines = imageLabelRow.textNumberOfLines
        self.label.lineBreakMode = imageLabelRow.textLineBreakMode
        self.label.text = imageLabelRow.text
    }

}

