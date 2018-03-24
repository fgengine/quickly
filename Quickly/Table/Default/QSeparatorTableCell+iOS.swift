//
//  Quickly
//

#if os(iOS)

    public class QSeparatorTableCell< RowType: QSeparatorTableRow >: QBackgroundColorTableCell< RowType > {

        private var _separator: QView!
        
        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            return row.edgeInsets.top + (1 / UIScreen.main.scale) + row.edgeInsets.bottom
        }

        open override func setup() {
            super.setup()

            self._separator = QView(frame: self.contentView.bounds)
            self._separator.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self._separator)
        }

        open override func set(row: RowType) {
            super.set(row: row)
            self.apply(row: row)
        }

        open override func update(row: RowType) {
            super.update(row: row)
            self.apply(row: row)
        }

        private func apply(row: QSeparatorTableRow) {
            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self._separator.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self._separator.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self._separator.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
            selfConstraints.append(self._separator.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            self.selfConstraints = selfConstraints

            self._separator.backgroundColor = row.color
        }

    }

#endif
