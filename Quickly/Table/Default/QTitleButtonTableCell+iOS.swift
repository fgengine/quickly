//
//  Quickly
//

#if os(iOS)

    public protocol QTitleButtonTableCellDelegate: IQTableCellDelegate {

        func pressedButton(_ row: QTitleButtonTableRow)

    }

    public class QTitleButtonTableCell< RowType: QTitleButtonTableRow >: QBackgroundColorTableCell< RowType > {

        open weak var titleButtonTableDelegate: QTitleButtonTableCellDelegate? {
            get{ return self.tableDelegate as? QTitleButtonTableCellDelegate }
        }

        private var _labelTitle: QLabel!
        private var _button: QButton!

        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            guard
                let text: IQText = row.titleText
                else { return 0 }
            let availableWidth: CGFloat = width - (row.edgeInsets.left + row.edgeInsets.right)
            let textSize: CGSize = text.size(width: availableWidth)
            return row.edgeInsets.top + max(textSize.height, row.buttonHeight) + row.edgeInsets.bottom
        }

        open override func setup() {
            super.setup()

            self._labelTitle = QLabel(frame: self.contentView.bounds)
            self._labelTitle.translatesAutoresizingMaskIntoConstraints = false
            self._labelTitle.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
            self._labelTitle.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
            self.contentView.addSubview(self._labelTitle)

            self._button = QButton(frame: self.contentView.bounds)
            self._button.translatesAutoresizingMaskIntoConstraints = false
            self._button.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
            self._button.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
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
                row.buttonIsSpinnerAnimating = true
                self._button.startSpinner()
            }
        }

        public func stopSpinner() {
            if let row: RowType = self.row {
                row.buttonIsSpinnerAnimating = false
                self._button.stopSpinner()
            }
        }

        private func apply(row: QTitleButtonTableRow) {
            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self._labelTitle.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self._labelTitle.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self._labelTitle.trailingLayout == self._button.leadingLayout - row.titleSpacing)
            selfConstraints.append(self._labelTitle.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            selfConstraints.append(self._button.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self._button.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
            selfConstraints.append(self._button.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            self.selfConstraints = selfConstraints

            self._labelTitle.contentAlignment = row.titleContentAlignment
            self._labelTitle.padding = row.titlePadding
            self._labelTitle.numberOfLines = row.titleNumberOfLines
            self._labelTitle.lineBreakMode = row.titleLineBreakMode
            self._labelTitle.text = row.titleText

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
            guard let row: RowType = self.row else {
                return
            }
            if let delegate: QTitleButtonTableCellDelegate = self.titleButtonTableDelegate {
                delegate.pressedButton(row as QTitleButtonTableRow)
            }
        }

    }

#endif
