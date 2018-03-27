//
//  Quickly
//

#if os(iOS)

    public class QTitleValueTableCell< RowType: QTitleValueTableRow >: QBackgroundColorTableCell< RowType > {

        private var _labelTitle: QLabel!
        private var _labelValue: QLabel!

        private var currentEdgeInsets: UIEdgeInsets?

        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            guard
                let titleText: IQText = row.titleText,
                let valueText: IQText = row.valueText
                else { return 0 }
            let availableWidth: CGFloat = width - (row.edgeInsets.left + row.edgeInsets.right)
            let valueTextSize: CGSize = valueText.size(width: availableWidth)
            let titleTextSize: CGSize = titleText.size(width: availableWidth - (valueTextSize.width + row.titleSpacing))
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
            if self.currentEdgeInsets != row.edgeInsets {
                self.currentEdgeInsets = row.edgeInsets

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

            self._labelTitle.contentAlignment = row.titleContentAlignment
            self._labelTitle.padding = row.titlePadding
            self._labelTitle.numberOfLines = row.titleNumberOfLines
            self._labelTitle.lineBreakMode = row.titleLineBreakMode
            self._labelTitle.text = row.titleText

            self._labelValue.contentAlignment = row.valueContentAlignment
            self._labelValue.padding = row.valuePadding
            self._labelValue.numberOfLines = row.valueNumberOfLines
            self._labelValue.lineBreakMode = row.valueLineBreakMode
            self._labelValue.text = row.valueText
        }

    }

#endif
