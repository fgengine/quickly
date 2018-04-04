//
//  Quickly
//

#if os(iOS)

    open class QLabelTableCell< RowType: QLabelTableRow >: QBackgroundColorTableCell< RowType > {

        private var _label: QLabel!
        
        private var currentEdgeInsets: UIEdgeInsets?

        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            let availableWidth = width - (row.edgeInsets.left + row.edgeInsets.right)
            let textSize = row.label.text.size(width: availableWidth)
            return row.edgeInsets.top + textSize.height + row.edgeInsets.bottom
        }

        open override func setup() {
            super.setup()

            self._label = QLabel(frame: self.contentView.bounds)
            self._label.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self._label)
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
            if self.currentEdgeInsets != row.edgeInsets {
                self.currentEdgeInsets = row.edgeInsets

                var selfConstraints: [NSLayoutConstraint] = []
                selfConstraints.append(self._label.topLayout == self.contentView.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._label.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
                selfConstraints.append(self._label.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
                selfConstraints.append(self._label.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
                self.selfConstraints = selfConstraints
            }
            row.label.apply(target: self._label)
        }

    }

#endif
