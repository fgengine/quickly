//
//  Quickly
//

#if os(iOS)

    public protocol QTitleButtonTableCellDelegate : IQTableCellDelegate {

        func pressedButton(_ row: QTitleButtonTableRow)

    }

    open class QTitleButtonTableCell< RowType: QTitleButtonTableRow >: QBackgroundColorTableCell< RowType > {

        open weak var titleButtonTableDelegate: QTitleButtonTableCellDelegate? {
            get{ return self.tableDelegate as? QTitleButtonTableCellDelegate }
        }

        private var _labelTitle: QLabel!
        private var _button: QButton!

        private var currentEdgeInsets: UIEdgeInsets?
        private var currentTitleSpacing: CGFloat?

        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            let availableWidth = width - (row.edgeInsets.left + row.edgeInsets.right)
            let textSize = row.title.text.size(width: availableWidth)
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
            if let row = self.row {
                row.buttonIsSpinnerAnimating = true
                self._button.startSpinner()
            }
        }

        public func stopSpinner() {
            if let row = self.row {
                row.buttonIsSpinnerAnimating = false
                self._button.stopSpinner()
            }
        }

        private func apply(row: QTitleButtonTableRow) {
            if self.currentEdgeInsets != row.edgeInsets || self.currentTitleSpacing != row.titleSpacing {
                self.currentEdgeInsets = row.edgeInsets
                self.currentTitleSpacing = row.titleSpacing

                var selfConstraints: [NSLayoutConstraint] = []
                selfConstraints.append(self._labelTitle.topLayout == self.contentView.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._labelTitle.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
                selfConstraints.append(self._labelTitle.trailingLayout == self._button.leadingLayout - row.titleSpacing)
                selfConstraints.append(self._labelTitle.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
                selfConstraints.append(self._button.topLayout == self.contentView.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._button.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
                selfConstraints.append(self._button.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
                self.selfConstraints = selfConstraints
            }
            row.title.apply(target: self._labelTitle)
            row.button.apply(target: self._button)
            if row.buttonIsSpinnerAnimating == true {
                self._button.startSpinner()
            } else {
                self._button.stopSpinner()
            }
        }

        @objc
        private func pressedButton(_ sender: Any) {
            guard let delegate = self.titleButtonTableDelegate, let row = self.row else { return }
            delegate.pressedButton(row as QTitleButtonTableRow)
        }

    }

#endif
