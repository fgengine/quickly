//
//  Quickly
//

import UIKit

public class QLabelPickerCell< RowType: QLabelPickerRow > : QPickerCell< RowType > {

    public private(set) lazy var labelView: QLabel = {
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
                self.labelView.topLayout == self.topLayout.offset(row.edgeInsets.top),
                self.labelView.leadingLayout == self.leadingLayout.offset(row.edgeInsets.left),
                self.labelView.trailingLayout == self.trailingLayout.offset(-row.edgeInsets.right),
                self.labelView.bottomLayout == self.bottomLayout.offset(-row.edgeInsets.bottom)
            ]
        }
        self.labelView.apply(row.label)
    }

}
