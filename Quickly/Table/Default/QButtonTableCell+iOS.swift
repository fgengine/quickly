//
//  Quickly
//

#if os(iOS)

    public protocol QButtonTableCellDelegate: IQTableCellDelegate {

        func pressedButton(_ row: QButtonTableRow)

    }

    public class QButtonTableCell< RowType: QButtonTableRow >: QBackgroundColorTableCell< RowType > {

        open weak var buttonTableDelegate: QButtonTableCellDelegate? {
            get{ return self.tableDelegate as? QButtonTableCellDelegate }
        }

        private var _button: QButton!

        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            return row.edgeInsets.top + row.height + row.edgeInsets.bottom
        }

        open override func setup() {
            super.setup()

            self._button = QButton(frame: self.contentView.bounds)
            self._button.translatesAutoresizingMaskIntoConstraints = false
            self._button.addTarget(self, action: #selector(self.pressedButton(_:)), for: .touchUpInside)
            self.contentView.addSubview(self._button)
        }

        open override func set(row: RowType) {
            super.set(row: row)
            self.apply(row: row)
        }

        open override func update(row: RowType) {
            super.update(row: row)
            self.apply(row: row)
        }

        public func isSpinnerAnimating() -> Bool {
            return self._button.isSpinnerAnimating()
        }

        public func startSpinner() {
            if let row: RowType = self.row {
                row.isSpinnerAnimating = true
                self._button.startSpinner()
            }
        }

        public func stopSpinner() {
            if let row: RowType = self.row {
                row.isSpinnerAnimating = false
                self._button.stopSpinner()
            }
        }

        private func apply(row: QButtonTableRow) {
            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self._button.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self._button.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self._button.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
            selfConstraints.append(self._button.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            self.selfConstraints = selfConstraints

            self._button.contentHorizontalAlignment = row.contentHorizontalAlignment
            self._button.contentVerticalAlignment = row.contentVerticalAlignment
            self._button.contentInsets = row.contentInsets
            self._button.imagePosition = row.imagePosition
            self._button.imageInsets = row.imageInsets
            self._button.textInsets = row.textInsets
            self._button.normalStyle = row.normalStyle
            self._button.highlightedStyle = row.highlightedStyle
            self._button.disabledStyle = row.disabledStyle
            self._button.selectedStyle = row.selectedStyle
            self._button.selectedHighlightedStyle = row.selectedHighlightedStyle
            self._button.selectedDisabledStyle = row.selectedDisabledStyle
            self._button.isSelected = row.isSelected
            self._button.isEnabled = row.isEnabled
            self._button.spinnerPosition = row.spinnerPosition
            self._button.spinnerView = row.spinnerView

            if row.isSpinnerAnimating == true {
                self._button.startSpinner()
            } else {
                self._button.stopSpinner()
            }

        }

        @objc
        private func pressedButton(_ sender: Any) {
            guard let row: RowType = self.row else {
                return
            }
            if let delegate: QButtonTableCellDelegate = self.buttonTableDelegate {
                delegate.pressedButton(row as QButtonTableRow)
            }
        }

    }

#endif
