//
//  Quickly
//

open class QBackgroundColorTableCell< RowType: QBackgroundColorTableRow >: QTableCell< RowType > {

    open override func set(row: RowType, animated: Bool) {
        super.set(row: row, animated: animated)

        if let backgroundColor = row.backgroundColor {
            self.backgroundColor = backgroundColor
            self.contentView.backgroundColor = backgroundColor
        }
        if let selectedBackgroundColor = row.selectedBackgroundColor {
            let view = UIView(frame: self.bounds)
            view.backgroundColor = selectedBackgroundColor
            self.selectedBackgroundView = view
        } else {
            self.selectedBackgroundView = nil
        }
    }

}
