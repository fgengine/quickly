//
//  Quickly
//

import UIKit

open class QTwoLabelTableCell< RowType: QTwoLabelTableRow >: QBackgroundColorTableCell< RowType > {

    internal var primaryLabel: QLabel!
    internal var secondaryLabel: QLabel!
    internal var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
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
        self.primaryLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.primaryLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self.primaryLabel)

        self.secondaryLabel = QLabel(frame: self.contentView.bounds)
        self.secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.secondaryLabel)
}

    open override func set(row: RowType) {
        super.set(row: row)
        self.apply(row: row)
    }

    open override func update(row: RowType) {
        super.update(row: row)
        self.apply(row: row)
    }

    private func apply(row: QTwoLabelTableRow) {
        var selfConstraints: [NSLayoutConstraint] = []
        selfConstraints.append(self.primaryLabel.topLayout == self.contentView.topLayout + row.edgeInsets.top)
        selfConstraints.append(self.primaryLabel.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
        selfConstraints.append(self.primaryLabel.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
        selfConstraints.append(self.primaryLabel.bottomLayout == self.secondaryLabel.topLayout - row.spacing)
        selfConstraints.append(self.secondaryLabel.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
        selfConstraints.append(self.secondaryLabel.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
        selfConstraints.append(self.secondaryLabel.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
        self.selfConstraints = selfConstraints

        self.primaryLabel.contentAlignment = row.primaryContentAlignment
        self.primaryLabel.padding = row.primaryPadding
        self.primaryLabel.numberOfLines = row.primaryNumberOfLines
        self.primaryLabel.lineBreakMode = row.primaryLineBreakMode
        self.primaryLabel.text = row.primaryText

        self.secondaryLabel.contentAlignment = row.secondaryContentAlignment
        self.secondaryLabel.padding = row.secondaryPadding
        self.secondaryLabel.numberOfLines = row.secondaryNumberOfLines
        self.secondaryLabel.lineBreakMode = row.secondaryLineBreakMode
        self.secondaryLabel.text = row.secondaryText
    }

}

