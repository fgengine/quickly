//
//  Quickly
//

public enum QCompositionTableRowSizeBehaviour {
    case dynamic
    case fixed(height: CGFloat)
    case bound(minimum: CGFloat, maximum: CGFloat)
}

open class QCompositionTableRow< Composable: IQComposable > : QBackgroundColorTableRow {

    public var composable: Composable
    public var sizeBehaviour: QCompositionTableRowSizeBehaviour

    public init(
        composable: Composable,
        sizeBehaviour: QCompositionTableRowSizeBehaviour = .dynamic,
        backgroundColor: UIColor? = nil,
        selectedBackgroundColor: UIColor? = nil,
        canSelect: Bool = true,
        canEdit: Bool = false,
        canMove: Bool = false,
        selectionStyle: UITableViewCell.SelectionStyle = .default,
        editingStyle: UITableViewCell.EditingStyle = .none
    ) {
        self.composable = composable
        self.sizeBehaviour = sizeBehaviour
        super.init(
            backgroundColor: backgroundColor,
            selectedBackgroundColor: selectedBackgroundColor,
            canSelect: canSelect,
            canEdit: canEdit,
            canMove: canMove,
            selectionStyle: selectionStyle,
            editingStyle: editingStyle
        )
    }

}

open class QCompositionTableCell< Composition: IQComposition > : QBackgroundColorTableCell< QCompositionTableRow< Composition.Composable > > {

    public private(set) var composition: Composition!

    open override class func height(row: RowType, spec: IQContainerSpec) -> CGFloat {
        switch row.sizeBehaviour {
        case .dynamic:
            return Composition.height(composable: row.composable, spec: spec)
        case .fixed(let height):
            return height
        case .bound(let minimum, let maximum):
            let height = Composition.height(composable: row.composable, spec: spec)
            return max(maximum, min(height, minimum))
        }
    }

    open override func setup() {
        super.setup()
        self.composition = Composition(contentView: self.contentView, owner: self)
    }

    open override func prepareForReuse() {
        self.composition.cleanup()
        super.prepareForReuse()
    }
    
    open override func set(row: RowType, spec: IQContainerSpec, animated: Bool) {
        super.set(row: row, spec: spec, animated: animated)
        self.composition.prepare(composable: row.composable, spec: spec, animated: animated)
    }
    
    private func scroll(animated: Bool) {
        guard let row = self.row, let controller = row.section?.controller else { return }
        controller.scroll(row: row, scroll: .middle, animated: animated)
    }

}

extension QCompositionTableCell : IQTextFieldObserver {
    
    open func beginEditing(textField: QTextField) {
        self.scroll(animated: true)
    }
    
    open func editing(textField: QTextField) {
    }
    
    open func endEditing(textField: QTextField) {
    }
    
    open func pressedClear(textField: QTextField) {
    }
    
    open func pressedReturn(textField: QTextField) {
    }
    
}

extension QCompositionTableCell : IQListFieldObserver {
    
    open func beginEditing(listField: QListField) {
        self.scroll(animated: true)
    }
    
    open func select(listField: QListField, row: QListFieldPickerRow) {
    }
    
    open func endEditing(listField: QListField) {
    }
    
}

extension QCompositionTableCell : IQDateFieldObserver {
    
    open func beginEditing(dateField: QDateField) {
        self.scroll(animated: true)
    }
    
    open func select(dateField: QDateField, date: Date) {
    }
    
    open func endEditing(dateField: QDateField) {
    }
    
}
