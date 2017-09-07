//
//  Quickly
//

import UIKit

open class QBackgroundColorTableCell< RowType: QBackgroundColorTableRow >: QTableCell< RowType > {

    open override func set(row: RowType) {
        super.set(row: row)
        self.apply(row: row)
    }

    open override func update(row: RowType) {
        super.update(row: row)
        self.apply(row: row)
    }

    private func apply(row: QBackgroundColorTableRow) {
        if let backgroundColor: UIColor = row.backgroundColor {
            self.backgroundColor = backgroundColor
            self.contentView.backgroundColor = backgroundColor
        }
    }

}

