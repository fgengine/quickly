//
//  Quickly
//

public class QLabelPickerCell< RowType: QLabelPickerRow > : QPickerCell< RowType > {

    private lazy var _label: QLabel = {
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
        if self._edgeInsets != row.edgeInsets {
            self._edgeInsets = row.edgeInsets
            self._constraints = [
                self._label.topLayout == self.topLayout + row.edgeInsets.top,
                self._label.leadingLayout == self.leadingLayout + row.edgeInsets.left,
                self._label.trailingLayout == self.trailingLayout - row.edgeInsets.right,
                self._label.bottomLayout == self.bottomLayout - row.edgeInsets.bottom
            ]
        }
        self._label.apply(row.label)
    }

}
