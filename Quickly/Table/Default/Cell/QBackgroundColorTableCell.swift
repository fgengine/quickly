//
//  Quickly
//

open class QBackgroundColorTableRow : QTableRow {

    public var backgroundColor: UIColor?
    public var selectedBackgroundColor: UIColor?

    public init(
        backgroundColor: UIColor? = nil,
        selectedBackgroundColor: UIColor? = nil,
        canSelect: Bool = true,
        canEdit: Bool = false,
        canMove: Bool = false,
        selectionStyle: UITableViewCell.SelectionStyle = .default,
        editingStyle: UITableViewCell.EditingStyle = .none
    ) {
        self.backgroundColor = backgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
        super.init(
            canSelect: canSelect,
            canEdit: canEdit,
            canMove: canMove,
            selectionStyle: selectionStyle,
            editingStyle: editingStyle
        )
    }
    
    @available(iOS 11.0, *)
    public init(
        backgroundColor: UIColor? = nil,
        selectedBackgroundColor: UIColor? = nil,
        canSelect: Bool = true,
        canEdit: Bool = false,
        canMove: Bool = false,
        selectionStyle: UITableViewCell.SelectionStyle = .default,
        editingStyle: UITableViewCell.EditingStyle = .none,
        leadingSwipeConfiguration: UISwipeActionsConfiguration? = nil,
        trailingSwipeConfiguration: UISwipeActionsConfiguration? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
        super.init(
            canSelect: canSelect,
            canEdit: canEdit,
            canMove: canMove,
            selectionStyle: selectionStyle,
            editingStyle: editingStyle,
            leadingSwipeConfiguration: leadingSwipeConfiguration,
            trailingSwipeConfiguration: trailingSwipeConfiguration
        )
    }

}

open class QBackgroundColorTableCell< RowType: QBackgroundColorTableRow > : QTableCell< RowType > {

    open override func set(row: RowType, spec: IQContainerSpec, animated: Bool) {
        super.set(row: row, spec: spec, animated: animated)

        self._applyContentBackgroundColor(
            row: row,
            highlighted: self.isHighlighted,
            selected: self.isSelected
        )
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if let row = self.row {
            self._applyContentBackgroundColor(
                row: row,
                highlighted: highlighted,
                selected: self.isSelected
            )
        }
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if let row = self.row {
            self._applyContentBackgroundColor(
                row: row,
                highlighted: self.isHighlighted,
                selected: selected
            )
        }
    }

    private func _applyContentBackgroundColor(row: RowType, highlighted: Bool, selected: Bool) {
        let backgroundColor = self._currentContentBackgroundColor(row: row, highlighted: highlighted, selected: selected)
        self.backgroundColor = backgroundColor
        self.contentView.backgroundColor = backgroundColor
    }

    private func _currentContentBackgroundColor(row: RowType, highlighted: Bool, selected: Bool) -> UIColor? {
        if let selectedBackgroundColor = row.selectedBackgroundColor {
            if selected == true || highlighted == true {
                return selectedBackgroundColor
            }
        }
        return row.backgroundColor
    }

}
