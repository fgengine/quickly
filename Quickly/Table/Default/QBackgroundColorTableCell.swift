//
//  Quickly
//

import UIKit

open class QBackgroundColorTableCell< RowType: QBackgroundColorTableRow >: QTableCell< RowType > {

    open override func set(row: RowType) {
        super.set(row: row)
        self.apply(backgroundColorRow: row)
    }

    open override func update(row: RowType) {
        super.update(row: row)
        self.apply(backgroundColorRow: row)
    }

    private func apply(backgroundColorRow: QBackgroundColorTableRow) {
        if let backgroundColor: UIColor = backgroundColorRow.backgroundColor {
            self.contentView.backgroundColor = backgroundColor
        }
    }

}

