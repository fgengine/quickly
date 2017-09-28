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
    internal var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
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
        self.apply(row: row)
    }

    open override func update(row: RowType) {
        super.update(row: row)
        self.apply(row: row)
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

    private func apply(row: QButtonTableRow) {
        var selfConstraints: [NSLayoutConstraint] = []
        selfConstraints.append(self.button.topLayout == self.contentView.topLayout + row.edgeInsets.top)
        selfConstraints.append(self.button.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
        selfConstraints.append(self.button.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
        selfConstraints.append(self.button.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
        self.selfConstraints = selfConstraints

        self.button.contentHorizontalAlignment = row.contentHorizontalAlignment
        self.button.contentVerticalAlignment = row.contentVerticalAlignment
        self.button.contentInsets = row.contentInsets
        self.button.imagePosition = row.imagePosition
        self.button.imageInsets = row.imageInsets
        self.button.textInsets = row.textInsets
        self.button.normalStyle = row.normalStyle
        self.button.highlightedStyle = row.highlightedStyle
        self.button.disabledStyle = row.disabledStyle
        self.button.selectedStyle = row.selectedStyle
        self.button.selectedHighlightedStyle = row.selectedHighlightedStyle
        self.button.selectedDisabledStyle = row.selectedDisabledStyle
        self.button.isSelected = row.isSelected
        self.button.isEnabled = row.isEnabled
        self.button.spinnerPosition = row.spinnerPosition
        self.button.spinnerView = row.spinnerView

        if row.isSpinnerAnimating == true {
            self.button.startSpinner()
        } else {
            self.button.stopSpinner()
        }

    }

    @IBAction private func pressedButton(_ sender: Any) {
        guard let row: RowType = self.row else {
            return
        }
        if let buttonTableDelegate: QButtonTableCellDelegate = self.buttonTableDelegate {
            buttonTableDelegate.pressedButton(row as QButtonTableRow)
        }
    }

}

