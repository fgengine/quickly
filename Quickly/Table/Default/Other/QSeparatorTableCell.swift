//
//  Quickly
//

import UIKit

open class QSeparatorTableCell: QTableCell< QSeparatorTableRow > {

    internal var separator: QView!
    internal var separatorConstraints: [NSLayoutConstraint] = [] {
        willSet {
            for constraint: NSLayoutConstraint in self.separatorConstraints {
                self.contentView.removeConstraint(constraint)
            }
            self.separatorConstraints.removeAll()
        }
        didSet {
            for constraint: NSLayoutConstraint in self.separatorConstraints {
                self.contentView.addConstraint(constraint)
            }
        }
    }

    open override func setup() {
        super.setup()

        self.separator = QView(frame: self.contentView.bounds)
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
        self.separatorConstraints = [
            self.separator.topLayout == self.contentView.topLayout + edgeInsetsRow.edgeInsets.top,
            self.separator.leadingLayout == self.contentView.leadingLayout + edgeInsetsRow.edgeInsets.left,
            self.separator.trailingLayout == self.contentView.trailingLayout + edgeInsetsRow.edgeInsets.right,
            self.separator.bottomLayout == self.contentView.bottomLayout + edgeInsetsRow.edgeInsets.bottom
        ]
    }

    private func apply(separatorRow: QSeparatorTableRow) {
        self.apply(edgeInsetsRow: separatorRow)
        self.separator.backgroundColor = separatorRow.color
    }
    
}

