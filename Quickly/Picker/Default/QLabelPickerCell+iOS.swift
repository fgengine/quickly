//
//  Quickly
//

#if os(iOS)

    public class QLabelPickerCell< RowType: QLabelPickerRow > : QPickerCell< RowType > {

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

        open override func set(row: RowType) {
            super.set(row: row)
            self.apply(row: row)
        }

        private func apply(row: QLabelPickerRow) {
            if self.currentEdgeInsets != row.edgeInsets {
                self.currentEdgeInsets = row.edgeInsets

                var selfConstraints: [NSLayoutConstraint] = []
                selfConstraints.append(self._label.topLayout == self.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._label.leadingLayout == self.leadingLayout + row.edgeInsets.left)
                selfConstraints.append(self._label.trailingLayout == self.trailingLayout - row.edgeInsets.right)
                selfConstraints.append(self._label.bottomLayout == self.bottomLayout - row.edgeInsets.bottom)
                self.selfConstraints = selfConstraints
            }
            row.label.apply(target: self._label)
        }

    }

#endif
