//
//  Quickly
//

import UIKit

public protocol QButtonTableCellDelegate: IQTableCellDelegate {

    func pressedButton(_ row: QButtonTableRow)

}

open class QButtonTableCell< RowType: QButtonTableRow >: QBackgroundColorTableCell< RowType > {

    public weak var buttonTableDelegate: QButtonTableCellDelegate? {
        get{ return self.tableDelegate as? QButtonTableCellDelegate }
    }

    internal var button: QButton!
    internal var currentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.currentConstraints) }
        didSet { self.contentView.addConstraints(self.currentConstraints) }
    }

    open override class func height(row: RowType, width: CGFloat) -> CGFloat {
        return row.edgeInsets.top + row.height + row.edgeInsets.bottom
    }

    open override func setup() {
        super.setup()

        self.button = QButton(frame: self.contentView.bounds)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.addTarget(self, action: #selector(self.pressedButton(_:)), for: .touchUpInside)
        self.contentView.addSubview(self.button)
    }

    open override func set(row: RowType) {
        super.set(row: row)
        self.apply(buttonRow: row)
    }

    open override func update(row: RowType) {
        super.update(row: row)
        self.apply(buttonRow: row)
    }

    public func isSpinnerAnimating() -> Bool {
        return self.button.isSpinnerAnimating()
    }

    public func startSpinner() {
        if let row: RowType = self.row {
            row.isSpinnerAnimating = true
            self.button.startSpinner()
        }
    }

    public func stopSpinner() {
        if let row: RowType = self.row {
            row.isSpinnerAnimating = false
            self.button.stopSpinner()
        }
    }

    private func apply(buttonRow: QButtonTableRow) {
        self.currentConstraints = [
            self.button.topLayout == self.contentView.topLayout + buttonRow.edgeInsets.top,
            self.button.leadingLayout == self.contentView.leadingLayout + buttonRow.edgeInsets.left,
            self.button.trailingLayout == self.contentView.trailingLayout - buttonRow.edgeInsets.right,
            self.button.bottomLayout == self.contentView.bottomLayout - buttonRow.edgeInsets.bottom
        ]

        self.button.contentHorizontalAlignment = buttonRow.contentHorizontalAlignment
        self.button.contentVerticalAlignment = buttonRow.contentVerticalAlignment
        self.button.contentInsets = buttonRow.contentInsets
        self.button.imagePosition = buttonRow.imagePosition
        self.button.imageInsets = buttonRow.imageInsets
        self.button.textInsets = buttonRow.textInsets
        self.button.normalStyle = buttonRow.normalStyle
        self.button.highlightedStyle = buttonRow.highlightedStyle
        self.button.disabledStyle = buttonRow.disabledStyle
        self.button.selectedStyle = buttonRow.selectedStyle
        self.button.selectedHighlightedStyle = buttonRow.selectedHighlightedStyle
        self.button.selectedDisabledStyle = buttonRow.selectedDisabledStyle
        self.button.spinnerPosition = buttonRow.spinnerPosition
        self.button.spinnerView = buttonRow.spinnerView

        if buttonRow.isSpinnerAnimating == true {
            self.button.startSpinner()
        } else {
            self.button.stopSpinner()
        }

    }

    @objc private func pressedButton(_ sender: Any) {
        guard let row: RowType = self.row else {
            return
        }
        if let buttonTableDelegate: QButtonTableCellDelegate = self.buttonTableDelegate {
            buttonTableDelegate.pressedButton(row as QButtonTableRow)
        }
    }

}

