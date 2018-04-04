//
//  Quickly
//

#if os(iOS)

    open class QTitleValueTableCell< RowType: QTitleValueTableRow >: QBackgroundColorTableCell< RowType > {

        private var _labelTitle: QLabel!
        private var _labelValue: QLabel!

        private var currentEdgeInsets: UIEdgeInsets?
        private var currentTitleSpacing: CGFloat?

        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            let availableWidth = width - (row.edgeInsets.left + row.edgeInsets.right)
            let valueTextSize = row.value.text.size(width: availableWidth)
            let titleTextSize = row.title.text.size(width: availableWidth - (valueTextSize.width + row.titleSpacing))
            return row.edgeInsets.top + max(titleTextSize.height, valueTextSize.height) + row.edgeInsets.bottom
        }

        open override func setup() {
            super.setup()

            self._labelTitle = QLabel(frame: self.contentView.bounds)
            self._labelTitle.translatesAutoresizingMaskIntoConstraints = false
            self._labelTitle.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
            self._labelTitle.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
            self.contentView.addSubview(self._labelTitle)

            self._labelValue = QLabel(frame: self.contentView.bounds)
            self._labelValue.translatesAutoresizingMaskIntoConstraints = false
            self._labelValue.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
            self._labelValue.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
            self.contentView.addSubview(self._labelValue)
    }

        open override func set(row: RowType) {
            super.set(row: row)
            self.apply(row: row)
        }

        open override func update(row: RowType) {
            super.update(row: row)
            self.apply(row: row)
        }

        private func apply(row: QTitleValueTableRow) {
            if self.currentEdgeInsets != row.edgeInsets || self.currentTitleSpacing != row.titleSpacing {
                self.currentEdgeInsets = row.edgeInsets
                self.currentTitleSpacing = row.titleSpacing

                var selfConstraints: [NSLayoutConstraint] = []
                selfConstraints.append(self._labelTitle.topLayout == self.contentView.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._labelTitle.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
                selfConstraints.append(self._labelTitle.trailingLayout == self._labelValue.leadingLayout - row.titleSpacing)
                selfConstraints.append(self._labelTitle.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
                selfConstraints.append(self._labelValue.topLayout == self.contentView.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._labelValue.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
                selfConstraints.append(self._labelValue.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
                self.selfConstraints = selfConstraints
            }
            row.title.apply(target: self._labelTitle)
            row.value.apply(target: self._labelValue)
        }

    }

#endif
