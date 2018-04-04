//
//  Quickly
//

#if os(iOS)

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

#endif
