//
//  Quickly
//

import UIKit

open class QLabelTableCell: QTableCell< QLabelTableRow > {

    internal var label: QLabel!
    internal var currentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.currentConstraints) }
        didSet { self.contentView.addConstraints(self.currentConstraints) }
    }

    open override class func height(row: QLabelTableRow, width: CGFloat) -> CGFloat {
        let availableWidth: CGFloat = width - (row.edgeInsets.left + row.edgeInsets.right)
        let textSize: CGSize = row.text.size(width: availableWidth)
        return row.edgeInsets.top + textSize.height + row.edgeInsets.bottom
    }

    open override func setup() {
        super.setup()

        self.label = QLabel(frame: self.contentView.bounds)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.label)
    }

    open override func set(row: QLabelTableRow) {
        super.set(row: row)
        self.apply(labelRow: row)
    }

    open override func update(row: QLabelTableRow) {
        super.update(row: row)
        self.apply(labelRow: row)
    }

    private func apply(colorRow: QColorTableRow) {
        if let backgroundColor: UIColor = colorRow.backgroundColor {
            self.contentView.backgroundColor = backgroundColor
        }
    }

    private func apply(edgeInsetsRow: QEdgeInsetsTableRow) {
        self.apply(colorRow: edgeInsetsRow)
        self.currentConstraints = [
            self.label.topLayout == self.contentView.topLayout + edgeInsetsRow.edgeInsets.top,
            self.label.leadingLayout == self.contentView.leadingLayout + edgeInsetsRow.edgeInsets.left,
            self.label.trailingLayout == self.contentView.trailingLayout - edgeInsetsRow.edgeInsets.right,
            self.label.bottomLayout == self.contentView.bottomLayout - edgeInsetsRow.edgeInsets.bottom
        ]
    }

    private func apply(labelRow: QLabelTableRow) {
        self.apply(edgeInsetsRow: labelRow)
        self.label.contentAlignment = labelRow.contentAlignment
        self.label.padding = labelRow.padding
        self.label.numberOfLines = labelRow.numberOfLines
        self.label.lineBreakMode = labelRow.lineBreakMode
        self.label.text = labelRow.text
    }

}

