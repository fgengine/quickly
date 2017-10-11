//
//  Quickly
//

#if os(iOS)

    open class QLabelTableCell< RowType: QLabelTableRow >: QBackgroundColorTableCell< RowType > {

        internal var label: QLabel!
        internal var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            guard let text: IQText = row.text else {
                return 0
            }
            let availableWidth: CGFloat = width - (row.edgeInsets.left + row.edgeInsets.right)
            let textSize: CGSize = text.size(width: availableWidth)
            return row.edgeInsets.top + textSize.height + row.edgeInsets.bottom
        }

        open override func setup() {
            super.setup()

            self.label = QLabel(frame: self.contentView.bounds)
            self.label.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.label)
        }

        open override func set(row: RowType) {
            super.set(row: row)
            self.apply(row: row)
        }

        open override func update(row: RowType) {
            super.update(row: row)
            self.apply(row: row)
        }

        private func apply(row: QLabelTableRow) {
            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.label.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self.label.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self.label.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
            selfConstraints.append(self.label.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            self.selfConstraints = selfConstraints

            self.label.contentAlignment = row.contentAlignment
            self.label.padding = row.padding
            self.label.numberOfLines = row.numberOfLines
            self.label.lineBreakMode = row.lineBreakMode
            self.label.text = row.text
        }

    }

#endif
