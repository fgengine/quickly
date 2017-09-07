//
//  Quickly
//

import UIKit

open class QSeparatorTableCell< RowType: QSeparatorTableRow >: QBackgroundColorTableCell< RowType > {

    internal var separator: QView!
    internal var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
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
        self.apply(row: row)
    }

    open override func update(row: RowType) {
        super.update(row: row)
        self.apply(row: row)
    }

    private func apply(row: QSeparatorTableRow) {
        self.selfConstraints = [
            self.separator.topLayout == self.contentView.topLayout + row.edgeInsets.top,
            self.separator.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left,
            self.separator.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right,
            self.separator.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom
        ]

        self.separator.backgroundColor = row.color
    }
    
}

