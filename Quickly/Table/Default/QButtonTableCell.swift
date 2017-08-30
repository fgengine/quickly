//
//  Quickly
//

import UIKit

open class QButtonTableCell< RowType: QButtonTableRow >: QBackgroundColorTableCell< RowType > {

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

}

