//
//  Quickly
//

#if os(iOS)

    public protocol QDateFieldTableCellDelegate : IQTableCellDelegate {

        func shouldBeginEditing(_ row: QDateFieldTableRow) -> Bool
        func beginEdititing(_ row: QDateFieldTableRow)
        func select(_ row: QDateFieldTableRow)
        func shouldEndEditing(_ row: QDateFieldTableRow) -> Bool
        func endEdititing(_ row: QDateFieldTableRow)

    }

    open class QDateFieldTableCell< RowType: QDateFieldTableRow >: QBackgroundColorTableCell< RowType > {

        open weak var dateFieldTableDelegate: QDateFieldTableCellDelegate? {
            get{ return self.tableDelegate as? QDateFieldTableCellDelegate }
        }

        private var _dateField: QDateField!
        
        private var currentEdgeInsets: UIEdgeInsets?

        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            return row.edgeInsets.top + row.fieldHeight + row.edgeInsets.bottom
        }

        open override func setup() {
            super.setup()

            self._dateField = QDateField(frame: self.contentView.bounds)
            self._dateField.translatesAutoresizingMaskIntoConstraints = false
            self._dateField.onShouldBeginEditing = { [weak self] (dateField: QDateField) in
                guard let strongify = self else { return true }
                return strongify.shouldBeginEditing()
            }
            self._dateField.onBeginEdititing = { [weak self] (dateField: QDateField) in
                guard let strongify = self else { return }
                strongify.beginEdititing()
            }
            self._dateField.onSelect = { [weak self] (dateField: QDateField, date: Date) in
                guard let strongify = self else { return }
                strongify.select(date)
            }
            self._dateField.onShouldEndEditing = { [weak self] (dateField: QDateField) in
                guard let strongify = self else { return true }
                return strongify.shouldEndEditing()
            }
            self._dateField.onEndEdititing = { [weak self] (dateField: QDateField) in
                guard let strongify = self else { return }
                strongify.endEdititing()
            }
            self.contentView.addSubview(self._dateField)
        }

        open override func set(row: RowType) {
            super.set(row: row)
            self.apply(row: row)
        }

        open override func update(row: RowType) {
            super.update(row: row)
            self.apply(row: row)
        }

        private func apply(row: QDateFieldTableRow) {
            if self.currentEdgeInsets != row.edgeInsets {
                self.currentEdgeInsets = row.edgeInsets

                var selfConstraints: [NSLayoutConstraint] = []
                selfConstraints.append(self._dateField.topLayout == self.contentView.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._dateField.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
                selfConstraints.append(self._dateField.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
                selfConstraints.append(self._dateField.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
                self.selfConstraints = selfConstraints
            }
            row.field.apply(target: self._dateField)
            self._dateField.date = row.fieldDate
        }

        private func shouldBeginEditing() -> Bool {
            guard let row = self.row, let delegate = self.dateFieldTableDelegate else { return true }
            return delegate.shouldBeginEditing(row as QDateFieldTableRow)
        }

        private func beginEdititing() {
            guard let row = self.row else { return }
            row.fieldIsEditing = self._dateField.isEditing
            guard let delegate = self.dateFieldTableDelegate else { return }
            return delegate.beginEdititing(row as QDateFieldTableRow)
        }

        private func select(_ date: Date) {
            guard let row = self.row else { return }
            row.fieldIsValid = self._dateField.isValid
            row.fieldDate = date
            guard let delegate = self.dateFieldTableDelegate else { return }
            return delegate.select(row as QDateFieldTableRow)
        }

        private func shouldEndEditing() -> Bool {
            guard let row = self.row, let delegate = self.dateFieldTableDelegate else { return true }
            return delegate.shouldEndEditing(row as QDateFieldTableRow)
        }

        private func endEdititing() {
            guard let row = self.row else { return }
            row.fieldIsEditing = self._dateField.isEditing
            guard let delegate = self.dateFieldTableDelegate else { return }
            return delegate.endEdititing(row as QDateFieldTableRow)
        }

    }

#endif
