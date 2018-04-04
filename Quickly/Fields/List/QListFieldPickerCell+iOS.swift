//
//  Quickly
//

#if os(iOS)

    public class QListFieldPickerCell : QPickerCell< QListFieldPickerRow > {

        private var _label: QLabel!

        private var currentEdgeInsets: UIEdgeInsets?

        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.removeConstraints(self.selfConstraints) }
            didSet { self.addConstraints(self.selfConstraints) }
        }

        open override func setup() {
            super.setup()

            self._label = QLabel(frame: self.bounds)
            self._label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self._label)
        }

        open override func set(row: QListFieldPickerRow) {
            super.set(row: row)
            self.apply(row: row)
        }

        private func apply(row: QListFieldPickerRow) {
            if self.currentEdgeInsets != row.rowEdgeInsets {
                self.currentEdgeInsets = row.rowEdgeInsets

                var selfConstraints: [NSLayoutConstraint] = []
                selfConstraints.append(self._label.topLayout == self.topLayout + row.rowEdgeInsets.top)
                selfConstraints.append(self._label.leadingLayout == self.leadingLayout + row.rowEdgeInsets.left)
                selfConstraints.append(self._label.trailingLayout == self.trailingLayout - row.rowEdgeInsets.right)
                selfConstraints.append(self._label.bottomLayout == self.bottomLayout - row.rowEdgeInsets.bottom)
                self.selfConstraints = selfConstraints
            }

            self._label.contentAlignment = row.rowContentAlignment
            self._label.padding = row.rowPadding
            self._label.numberOfLines = row.rowNumberOfLines
            self._label.lineBreakMode = row.rowLineBreakMode
            self._label.text = row.rowText
        }

    }

#endif
