//
//  Quickly
//

public class QListFieldPickerCell : QPickerCell< QListFieldPickerRow > {

    private var _title: QLabel!

    private var currentEdgeInsets: UIEdgeInsets?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self.selfConstraints) }
        didSet { self.addConstraints(self.selfConstraints) }
    }

    open override func setup() {
        super.setup()

        self._title = QLabel(frame: self.bounds)
        self._title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self._title)
    }

    open override func set(row: QListFieldPickerRow) {
        super.set(row: row)
        self.apply(row: row)
    }

    private func apply(row: QListFieldPickerRow) {
        if self.currentEdgeInsets != row.rowEdgeInsets {
            self.currentEdgeInsets = row.rowEdgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self._title.topLayout == self.topLayout + row.rowEdgeInsets.top)
            selfConstraints.append(self._title.leadingLayout == self.leadingLayout + row.rowEdgeInsets.left)
            selfConstraints.append(self._title.trailingLayout == self.trailingLayout - row.rowEdgeInsets.right)
            selfConstraints.append(self._title.bottomLayout == self.bottomLayout - row.rowEdgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        row.row.apply(self._title)
    }

}
