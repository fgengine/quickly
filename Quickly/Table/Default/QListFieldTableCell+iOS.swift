//
//  Quickly
//

#if os(iOS)

    public protocol QListFieldTableCellDelegate : IQTableCellDelegate {

        func shouldBeginEditing(_ row: QListFieldTableRow) -> Bool
        func beginEdititing(_ row: QListFieldTableRow)
        func select(_ row: QListFieldTableRow)
        func shouldEndEditing(_ row: QListFieldTableRow) -> Bool
        func endEdititing(_ row: QListFieldTableRow)

    }

    open class QListFieldTableCell< RowType: QListFieldTableRow >: QBackgroundColorTableCell< RowType > {

        open weak var listFieldTableDelegate: QListFieldTableCellDelegate? {
            get{ return self.tableDelegate as? QListFieldTableCellDelegate }
        }

        private var _listField: QListField!
        
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

            self._listField = QListField(frame: self.contentView.bounds)
            self._listField.translatesAutoresizingMaskIntoConstraints = false
            self._listField.onShouldBeginEditing = { [weak self] (listField: QListField) in
                guard let strongify = self else { return true }
                return strongify.shouldBeginEditing()
            }
            self._listField.onBeginEdititing = { [weak self] (listField: QListField) in
                guard let strongify = self else { return }
                strongify.beginEdititing()
            }
            self._listField.onSelect = { [weak self] (listField: QListField, row: QListFieldPickerRow) in
                guard let strongify = self else { return }
                strongify.select(row)
            }
            self._listField.onShouldEndEditing = { [weak self] (listField: QListField) in
                guard let strongify = self else { return true }
                return strongify.shouldEndEditing()
            }
            self._listField.onEndEdititing = { [weak self] (listField: QListField) in
                guard let strongify = self else { return }
                strongify.endEdititing()
            }
            self.contentView.addSubview(self._listField)
        }

        open override func set(row: RowType) {
            super.set(row: row)
            self.apply(row: row)
        }

        open override func update(row: RowType) {
            super.update(row: row)
            self.apply(row: row)
        }

        private func apply(row: QListFieldTableRow) {
            if self.currentEdgeInsets != row.edgeInsets {
                self.currentEdgeInsets = row.edgeInsets

                var selfConstraints: [NSLayoutConstraint] = []
                selfConstraints.append(self._listField.topLayout == self.contentView.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._listField.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
                selfConstraints.append(self._listField.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
                selfConstraints.append(self._listField.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
                self.selfConstraints = selfConstraints
            }
            row.field.apply(target: self._listField)
            self._listField.selectedRow = row.fieldSelectedRow
        }

        private func shouldBeginEditing() -> Bool {
            guard let row = self.row, let delegate = self.listFieldTableDelegate else { return true }
            return delegate.shouldBeginEditing(row as QListFieldTableRow)
        }

        private func beginEdititing() {
            guard let row = self.row else { return }
            row.fieldIsEditing = self._listField.isEditing
            guard let delegate = self.listFieldTableDelegate else { return }
            return delegate.beginEdititing(row as QListFieldTableRow)
        }

        private func select(_ pickerRow: QListFieldPickerRow) {
            guard let row = self.row else { return }
            row.fieldIsValid = self._listField.isValid
            row.fieldSelectedRow = pickerRow
            guard let delegate = self.listFieldTableDelegate else { return }
            return delegate.select(row as QListFieldTableRow)
        }

        private func shouldEndEditing() -> Bool {
            guard let row = self.row, let delegate = self.listFieldTableDelegate else { return true }
            return delegate.shouldEndEditing(row as QListFieldTableRow)
        }

        private func endEdititing() {
            guard let row = self.row else { return }
            row.fieldIsEditing = self._listField.isEditing
            guard let delegate = self.listFieldTableDelegate else { return }
            return delegate.endEdititing(row as QListFieldTableRow)
        }

    }

#endif
