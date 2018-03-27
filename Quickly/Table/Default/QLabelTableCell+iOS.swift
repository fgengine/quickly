//
//  Quickly
//

#if os(iOS)

    public class QLabelTableCell< RowType: QLabelTableRow >: QBackgroundColorTableCell< RowType > {

        private var _label: QLabel!
        
        private var currentEdgeInsets: UIEdgeInsets?

        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            guard
                let text: IQText = row.labelText
                else { return 0 }
            let availableWidth: CGFloat = width - (row.edgeInsets.left + row.edgeInsets.right)
            let textSize: CGSize = text.size(width: availableWidth)
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

            self._label.contentAlignment = row.labelContentAlignment
            self._label.padding = row.labelPadding
            self._label.numberOfLines = row.labelNumberOfLines
            self._label.lineBreakMode = row.labelLineBreakMode
            self._label.text = row.labelText
        }

    }

#endif
