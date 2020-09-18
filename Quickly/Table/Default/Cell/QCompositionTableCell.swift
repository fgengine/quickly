//
//  Quickly
//

public enum QCompositionTableRowSizeBehaviour {
    case dynamic
    case full
    case fixed(height: CGFloat)
    case bound(minimum: CGFloat, maximum: CGFloat)
}

open class QCompositionTableRow< Composable: IQComposable > : QBackgroundColorTableRow {

    public var composable: Composable
    public var selectedComposable: Composable?
    public var sizeBehaviour: QCompositionTableRowSizeBehaviour

    public init(
        composable: Composable,
        selectedComposable: Composable? = nil,
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
        self.selectedComposable = selectedComposable
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
    
    @available(iOS 11.0, *)
    public init(
        composable: Composable,
        selectedComposable: Composable? = nil,
        sizeBehaviour: QCompositionTableRowSizeBehaviour = .dynamic,
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
        self.composable = composable
        self.selectedComposable = selectedComposable
        self.sizeBehaviour = sizeBehaviour
        super.init(
            backgroundColor: backgroundColor,
            selectedBackgroundColor: selectedBackgroundColor,
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

open class QCompositionTableCell< Composition: IQComposition > : QBackgroundColorTableCell< QCompositionTableRow< Composition.Composable > >, IQTextFieldObserver, IQMultiTextFieldObserver, IQListFieldObserver, IQDateFieldObserver {

    public private(set) var composition: Composition!

    open override class func height(row: RowType, spec: IQContainerSpec) -> CGFloat {
        switch row.sizeBehaviour {
        case .dynamic:
            return Composition.height(composable: row.composable, spec: spec)
        case .full:
            return spec.containerSize.height
        case .fixed(let height):
            return height
        case .bound(let minimum, let maximum):
            let height = Composition.height(composable: row.composable, spec: spec)
            return max(maximum, min(height, minimum))
        }
    }

    open override func setup() {
        super.setup()
        
        self.clipsToBounds = true
        
        self.composition = Composition(contentView: self.contentView, owner: self)
    }

    open override func prepareForReuse() {
        self.composition.cleanup()
        super.prepareForReuse()
    }
    
    open override func prepare(row: RowType, spec: IQContainerSpec, animated: Bool) {
        super.prepare(row: row, spec: spec, animated: animated)
        self._prepareComposition(row: row, spec: spec, highlighted: self.isHighlighted, selected: self.isSelected, animated: animated)
    }
    
    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if let row = self.row, let spec = self.composition.spec {
            self._prepareComposition(row: row, spec: spec, highlighted: highlighted, selected: self.isSelected, animated: animated)
        }
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if let row = self.row, let spec = self.composition.spec {
            self._prepareComposition(row: row, spec: spec, highlighted: self.isHighlighted, selected: selected, animated: animated)
        }
    }

    // MARK: IQTextFieldObserver
    
    open func beginEditing(textField: QTextField) {
        self._scroll(animated: true)
    }
    
    open func editing(textField: QTextField) {
    }
    
    open func endEditing(textField: QTextField) {
    }
    
    open func pressed(textField: QTextField, action: QFieldAction) {
    }
    
    open func pressedClear(textField: QTextField) {
    }
    
    open func pressedReturn(textField: QTextField) {
    }
    
    open func select(textField: QTextField, suggestion: String) {
    }
    
    // MARK: IQMultiTextFieldObserver
    
    open func beginEditing(multiTextField: QMultiTextField) {
        self._scroll(animated: true)
    }
    
    open func editing(multiTextField: QMultiTextField) {
    }
    
    open func endEditing(multiTextField: QMultiTextField) {
    }
    
    open func pressed(multiTextField: QMultiTextField, action: QFieldAction) {
    }
    
    open func changed(multiTextField: QMultiTextField, height: CGFloat) {
        guard let row = self.row, let section = row.section, let controller = section.controller else { return }
        controller.performBatchUpdates({
            row.resetCacheHeight()
        })
    }
    
    // MARK: IQListFieldObserver
    
    open func beginEditing(listField: QListField) {
        self._scroll(animated: true)
    }
    
    open func select(listField: QListField, row: QListFieldPickerRow) {
    }
    
    open func endEditing(listField: QListField) {
    }
    
    open func pressed(listField: QListField, action: QFieldAction) {
    }
    
    // MARK: IQDateFieldObserver
    
    open func beginEditing(dateField: QDateField) {
        self._scroll(animated: true)
    }
    
    open func select(dateField: QDateField, date: Date) {
    }
    
    open func endEditing(dateField: QDateField) {
    }
    
    open func pressed(dateField: QDateField, action: QFieldAction) {
    }
    
    // MARK: Private
    
    private func _prepareComposition(row: RowType, spec: IQContainerSpec, highlighted: Bool, selected: Bool, animated: Bool) {
        let composable = self._currentComposable(row: row, highlighted: highlighted, selected: selected)
        self.composition.prepare(
            composable: composable,
            spec: spec,
            animated: animated
        )
    }
    
    private func _currentComposable(row: RowType, highlighted: Bool, selected: Bool) -> Composition.Composable {
        if selected == true || highlighted == true {
            if let selectedComposable = row.selectedComposable {
                return selectedComposable
            }
        }
        return row.composable
    }
    
    private func _scroll(animated: Bool) {
        guard let row = self.row, let controller = row.section?.controller else { return }
        controller.scroll(row: row, scroll: .middle, animated: animated)
    }
    
}
