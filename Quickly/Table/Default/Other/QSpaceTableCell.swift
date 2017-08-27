//
//  Quickly
//

import UIKit

open class QSpaceTableCell: QTableCell< QSpaceTableRow > {

    open override func set(row: QSpaceTableRow) {
        super.set(row: row)
        self.apply(colorRow: row)
    }

    open override func update(row: QSpaceTableRow) {
        super.update(row: row)
        self.apply(colorRow: row)
    }

    private func apply(colorRow: QColorTableRow) {
        if let backgroundColor: UIColor = colorRow.backgroundColor {
            self.contentView.backgroundColor = backgroundColor
        }
    }

}

