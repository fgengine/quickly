//
//  Quickly
//

#if os(iOS)

    public protocol QTextFieldTableCellDelegate : IQTableCellDelegate {

        func shouldBeginEditing(_ row: QTextFieldTableRow) -> Bool
        func beginEdititing(_ row: QTextFieldTableRow)
        func edititing(_ row: QTextFieldTableRow)
        func shouldEndEditing(_ row: QTextFieldTableRow) -> Bool
        func endEdititing(_ row: QTextFieldTableRow)
        func shouldClear(_ row: QTextFieldTableRow) -> Bool
        func pressedClear(_ row: QTextFieldTableRow)
        func shouldReturn(_ row: QTextFieldTableRow) -> Bool
        func pressedReturn(_ row: QTextFieldTableRow)

    }

    open class QTextFieldTableCell< RowType: QTextFieldTableRow >: QBackgroundColorTableCell< RowType > {

        open weak var textFieldTableDelegate: QTextFieldTableCellDelegate? {
            get{ return self.tableDelegate as? QTextFieldTableCellDelegate }
        }

        private var _textField: QTextField!
        
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

            self._textField = QTextField(frame: self.contentView.bounds)
            self._textField.translatesAutoresizingMaskIntoConstraints = false
            self._textField.onShouldBeginEditing = { [weak self] (textField: QTextField) in
                guard let strongify = self else { return true }
                return strongify.shouldBeginEditing()
            }
            self._textField.onBeginEdititing = { [weak self] (textField: QTextField) in
                guard let strongify = self else { return }
                strongify.beginEdititing()
            }
            self._textField.onEdititing = { [weak self] (textField: QTextField) in
                guard let strongify = self else { return }
                strongify.edititing()
            }
            self._textField.onShouldEndEditing = { [weak self] (textField: QTextField) in
                guard let strongify = self else { return true }
                return strongify.shouldEndEditing()
            }
            self._textField.onEndEdititing = { [weak self] (textField: QTextField) in
                guard let strongify = self else { return }
                strongify.endEdititing()
            }
            self._textField.onShouldClear = { [weak self] (textField: QTextField) in
                guard let strongify = self else { return true }
                return strongify.shouldClear()
            }
            self._textField.onPressedClear = { [weak self] (textField: QTextField) in
                guard let strongify = self else { return }
                strongify.pressedClear()
            }
            self._textField.onShouldReturn = { [weak self] (textField: QTextField) in
                guard let strongify = self else { return true }
                return strongify.shouldReturn()
            }
            self._textField.onPressedReturn = { [weak self] (textField: QTextField) in
                guard let strongify = self else { return }
                strongify.pressedReturn()
            }
            self.contentView.addSubview(self._textField)
        }

        open override func set(row: RowType) {
            super.set(row: row)
            self.apply(row: row)
        }

        open override func update(row: RowType) {
            super.update(row: row)
            self.apply(row: row)
        }

        private func apply(row: QTextFieldTableRow) {
            if self.currentEdgeInsets != row.edgeInsets {
                self.currentEdgeInsets = row.edgeInsets

                var selfConstraints: [NSLayoutConstraint] = []
                selfConstraints.append(self._textField.topLayout == self.contentView.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._textField.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
                selfConstraints.append(self._textField.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
                selfConstraints.append(self._textField.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
                self.selfConstraints = selfConstraints
            }
            row.field.apply(target: self._textField)
            self._textField.unformatText = row.fieldText
        }

        private func shouldBeginEditing() -> Bool {
            guard let row = self.row, let delegate = self.textFieldTableDelegate else { return true }
            return delegate.shouldBeginEditing(row as QTextFieldTableRow)
        }

        private func beginEdititing() {
            guard let row = self.row else { return }
            row.fieldIsEditing = self._textField.isEditing
            guard let delegate = self.textFieldTableDelegate else { return }
            return delegate.beginEdititing(row as QTextFieldTableRow)
        }

        private func edititing() {
            guard let row = self.row else { return }
            row.fieldIsValid = self._textField.isValid
            row.fieldText = self._textField.unformatText
            guard let delegate = self.textFieldTableDelegate else { return }
            return delegate.edititing(row as QTextFieldTableRow)
        }

        private func shouldEndEditing() -> Bool {
            guard let row = self.row, let delegate = self.textFieldTableDelegate else { return true }
            return delegate.shouldEndEditing(row as QTextFieldTableRow)
        }

        private func endEdititing() {
            guard let row = self.row else { return }
            row.fieldIsEditing = self._textField.isEditing
            guard let delegate = self.textFieldTableDelegate else { return }
            return delegate.endEdititing(row as QTextFieldTableRow)
        }

        private func shouldClear() -> Bool {
            guard let row = self.row, let delegate = self.textFieldTableDelegate else { return true }
            return delegate.shouldClear(row as QTextFieldTableRow)
        }

        private func pressedClear() {
            guard let row = self.row else { return }
            row.fieldIsValid = self._textField.isValid
            row.fieldText = self._textField.unformatText
            guard let delegate = self.textFieldTableDelegate else { return }
            return delegate.endEdititing(row as QTextFieldTableRow)
        }

        private func shouldReturn() -> Bool {
            guard let row = self.row, let delegate = self.textFieldTableDelegate else { return true }
            return delegate.shouldClear(row as QTextFieldTableRow)
        }

        private func pressedReturn() {
            guard let row = self.row, let delegate = self.textFieldTableDelegate else { return }
            delegate.pressedReturn(row as QTextFieldTableRow)
        }

    }

#endif
