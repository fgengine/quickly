//
//  Quickly
//

import UIKit

open class QSeparatorTableCell< RowType: QSeparatorTableRow >: QBackgroundColorTableCell< RowType > {

    internal var separator: QView!
    internal var currentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.currentConstraints) }
        didSet { self.contentView.addConstraints(self.currentConstraints) }
    }

    open override class func height(row: RowType, width: CGFloat) -> CGFloat {
        return row.edgeInsets.top + (1 / UIScreen.main.scale) + row.edgeInsets.bottom
    }

    open override func setup() {
        super.setup()

        self.separator = QView(frame: self.contentView.bounds)
        self.separator.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.separator)
    }

    open override func set(row: RowType) {
        super.set(row: row)
        self.apply(separatorRow: row)
    }

    open override func update(row: RowType) {
        super.update(row: row)
        self.apply(separatorRow: row)
    }

    private func apply(separatorRow: QSeparatorTableRow) {
        self.currentConstraints = [
            self.separator.topLayout == self.contentView.topLayout + separatorRow.edgeInsets.top,
            self.separator.leadingLayout == self.contentView.leadingLayout + separatorRow.edgeInsets.left,
            self.separator.trailingLayout == self.contentView.trailingLayout - separatorRow.edgeInsets.right,
            self.separator.bottomLayout == self.contentView.bottomLayout - separatorRow.edgeInsets.bottom
        ]

        self.separator.backgroundColor = separatorRow.color
    }
    
}

