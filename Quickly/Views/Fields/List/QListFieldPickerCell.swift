//
//  Quickly
//

public class QListFieldPickerCell : QPickerCell< QListFieldPickerRow > {

    private lazy var _title: QLabel = {
        let view = QLabel(frame: self.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        return view
    }()

    private var _edgeInsets: UIEdgeInsets?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self._constraints) }
        didSet { self.addConstraints(self._constraints) }
    }

    open override func set(row: RowType) {
        super.set(row: row)
        self._apply(row: row)
    }

    private func _apply(row: RowType) {
        if self._edgeInsets != row.rowEdgeInsets {
            self._edgeInsets = row.rowEdgeInsets
            self._constraints = [
                self._title.topLayout == self.topLayout.offset(row.rowEdgeInsets.top),
                self._title.leadingLayout == self.leadingLayout.offset(row.rowEdgeInsets.left),
                self._title.trailingLayout == self.trailingLayout.offset(-row.rowEdgeInsets.right),
                self._title.bottomLayout == self.bottomLayout.offset(-row.rowEdgeInsets.bottom)
            ]
        }
        self._title.apply(row.row)
    }

}
