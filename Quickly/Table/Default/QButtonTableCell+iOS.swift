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
        
        private var currentEdgeInsets: UIEdgeInsets?

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
            guard let row: RowType = self.row else { return }
            row.buttonIsSpinnerAnimating = true
            self._button.startSpinner()
        }

        public func stopSpinner() {
            guard let row: RowType = self.row else { return }
            row.buttonIsSpinnerAnimating = false
            self._button.stopSpinner()
        }

        private func apply(row: QButtonTableRow) {
            if self.currentEdgeInsets != row.edgeInsets {
                self.currentEdgeInsets = row.edgeInsets
                
                var selfConstraints: [NSLayoutConstraint] = []
                selfConstraints.append(self._button.topLayout == self.contentView.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._button.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
                selfConstraints.append(self._button.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
                selfConstraints.append(self._button.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
                self.selfConstraints = selfConstraints
            }

            self._button.contentHorizontalAlignment = row.buttonContentHorizontalAlignment
            self._button.contentVerticalAlignment = row.buttonContentVerticalAlignment
            self._button.contentInsets = row.buttonContentInsets
            self._button.imagePosition = row.buttonImagePosition
            self._button.imageInsets = row.buttonImageInsets
            self._button.textInsets = row.buttonTextInsets
            self._button.normalStyle = row.buttonNormalStyle
            self._button.highlightedStyle = row.buttonHighlightedStyle
            self._button.disabledStyle = row.buttonDisabledStyle
            self._button.selectedStyle = row.buttonSelectedStyle
            self._button.selectedHighlightedStyle = row.buttonSelectedHighlightedStyle
            self._button.selectedDisabledStyle = row.buttonSelectedDisabledStyle
            self._button.isSelected = row.buttonIsSelected
            self._button.isEnabled = row.buttonIsEnabled
            self._button.spinnerPosition = row.buttonSpinnerPosition
            self._button.spinnerView = row.buttonSpinnerView

            if row.buttonIsSpinnerAnimating == true {
                self._button.startSpinner()
            } else {
                self._button.stopSpinner()
            }

        }

        @objc
        private func pressedButton(_ sender: Any) {
            guard let delegate: QButtonTableCellDelegate = self.buttonTableDelegate, let row: RowType = self.row else { return }
            delegate.pressedButton(row as QButtonTableRow)
        }

    }

#endif
