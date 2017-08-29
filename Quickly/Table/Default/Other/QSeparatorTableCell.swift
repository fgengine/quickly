//
//  Quickly
//

import UIKit

open class QSeparatorTableCell: QTableCell< QSeparatorTableRow > {

    internal var separator: QView!
    internal var currentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.currentConstraints) }
        didSet { self.contentView.addConstraints(self.currentConstraints) }
    }

    open override class func height(row: QSeparatorTableRow, width: CGFloat) -> CGFloat {
        return row.edgeInsets.top + (1 / UIScreen.main.scale) + row.edgeInsets.bottom
    }

    open override func setup() {
        super.setup()

        self.separator = QView(frame: self.contentView.bounds)
        self.separator.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.separator)
    }

    open override func set(row: QSeparatorTableRow) {
        super.set(row: row)
        self.apply(separatorRow: row)
    }

    open override func update(row: QSeparatorTableRow) {
        super.update(row: row)
        self.apply(separatorRow: row)
    }

    private func apply(colorRow: QColorTableRow) {
        if let backgroundColor: UIColor = colorRow.backgroundColor {
            self.contentView.backgroundColor = backgroundColor
        }
    }

    private func apply(edgeInsetsRow: QEdgeInsetsTableRow) {
        self.apply(colorRow: edgeInsetsRow)
        self.currentConstraints = [
            self.separator.topLayout == self.contentView.topLayout + edgeInsetsRow.edgeInsets.top,
            self.separator.leadingLayout == self.contentView.leadingLayout + edgeInsetsRow.edgeInsets.left,
            self.separator.trailingLayout == self.contentView.trailingLayout - edgeInsetsRow.edgeInsets.right,
            self.separator.bottomLayout == self.contentView.bottomLayout - edgeInsetsRow.edgeInsets.bottom
        ]
    }

    private func apply(separatorRow: QSeparatorTableRow) {
        self.apply(edgeInsetsRow: separatorRow)
        self.separator.backgroundColor = separatorRow.color
    }
    
}

