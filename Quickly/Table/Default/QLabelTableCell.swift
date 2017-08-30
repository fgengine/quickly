//
//  Quickly
//

import UIKit

open class QLabelTableCell< RowType: QLabelTableRow >: QBackgroundColorTableCell< RowType > {

    internal var label: QLabel!
    internal var currentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.currentConstraints) }
        didSet { self.contentView.addConstraints(self.currentConstraints) }
    }

    open override class func height(row: RowType, width: CGFloat) -> CGFloat {
        guard let text: IQText = row.text else {
            return 0
        }
        let availableWidth: CGFloat = width - (row.edgeInsets.left + row.edgeInsets.right)
        let textSize: CGSize = text.size(width: availableWidth)
        return row.edgeInsets.top + textSize.height + row.edgeInsets.bottom
    }

    open override func setup() {
        super.setup()

        self.label = QLabel(frame: self.contentView.bounds)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.label)
    }

    open override func set(row: RowType) {
        super.set(row: row)
        self.apply(labelRow: row)
    }

    open override func update(row: RowType) {
        super.update(row: row)
        self.apply(labelRow: row)
    }

    private func apply(labelRow: QLabelTableRow) {
        self.currentConstraints = [
            self.label.topLayout == self.contentView.topLayout + labelRow.edgeInsets.top,
            self.label.leadingLayout == self.contentView.leadingLayout + labelRow.edgeInsets.left,
            self.label.trailingLayout == self.contentView.trailingLayout - labelRow.edgeInsets.right,
            self.label.bottomLayout == self.contentView.bottomLayout - labelRow.edgeInsets.bottom
        ]

        self.label.contentAlignment = labelRow.contentAlignment
        self.label.padding = labelRow.padding
        self.label.numberOfLines = labelRow.numberOfLines
        self.label.lineBreakMode = labelRow.lineBreakMode
        self.label.text = labelRow.text
    }

}

