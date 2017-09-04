//
//  Quickly
//

import UIKit

open class QTwoLabelTableCell< RowType: QTwoLabelTableRow >: QBackgroundColorTableCell< RowType > {

    internal var primaryLabel: QLabel!
    internal var secondaryLabel: QLabel!
    internal var currentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.currentConstraints) }
        didSet { self.contentView.addConstraints(self.currentConstraints) }
    }

    open override class func height(row: RowType, width: CGFloat) -> CGFloat {
        guard let primaryText: IQText = row.primaryText, let secondaryText: IQText = row.secondaryText else {
            return 0
        }
        let availableWidth: CGFloat = width - (row.edgeInsets.left + row.edgeInsets.right)
        let primaryTextSize: CGSize = primaryText.size(width: availableWidth)
        let secondaryTextSize: CGSize = secondaryText.size(width: availableWidth)
        return row.edgeInsets.top + primaryTextSize.height + row.spacing + secondaryTextSize.height + row.edgeInsets.bottom
    }

    open override func setup() {
        super.setup()

        self.primaryLabel = QLabel(frame: self.contentView.bounds)
        self.primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.primaryLabel)

        self.secondaryLabel = QLabel(frame: self.contentView.bounds)
        self.secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.secondaryLabel)
}

    open override func set(row: RowType) {
        super.set(row: row)
        self.apply(labelRow: row)
    }

    open override func update(row: RowType) {
        super.update(row: row)
        self.apply(labelRow: row)
    }

    private func apply(labelRow: QTwoLabelTableRow) {
        self.currentConstraints = [
            self.primaryLabel.topLayout == self.contentView.topLayout + labelRow.edgeInsets.top,
            self.primaryLabel.leadingLayout == self.contentView.leadingLayout + labelRow.edgeInsets.left,
            self.primaryLabel.trailingLayout == self.contentView.trailingLayout - labelRow.edgeInsets.right,
            self.primaryLabel.bottomLayout == self.secondaryLabel.topLayout - labelRow.spacing,
            self.secondaryLabel.leadingLayout == self.contentView.leadingLayout + labelRow.edgeInsets.left,
            self.secondaryLabel.trailingLayout == self.contentView.trailingLayout - labelRow.edgeInsets.right,
            self.secondaryLabel.bottomLayout == self.contentView.bottomLayout - labelRow.edgeInsets.bottom
        ]

        self.primaryLabel.contentAlignment = labelRow.primaryContentAlignment
        self.primaryLabel.padding = labelRow.primaryPadding
        self.primaryLabel.numberOfLines = labelRow.primaryNumberOfLines
        self.primaryLabel.lineBreakMode = labelRow.primaryLineBreakMode
        self.primaryLabel.text = labelRow.primaryText

        self.secondaryLabel.contentAlignment = labelRow.secondaryContentAlignment
        self.secondaryLabel.padding = labelRow.secondaryPadding
        self.secondaryLabel.numberOfLines = labelRow.secondaryNumberOfLines
        self.secondaryLabel.lineBreakMode = labelRow.secondaryLineBreakMode
        self.secondaryLabel.text = labelRow.secondaryText
    }

}

