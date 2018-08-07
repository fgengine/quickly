//
//  Quickly
//

open class QCompositionTableRow< Composable: IQComposable > : QBackgroundColorTableRow {

    public var composable: Composable

    public init(composable: Composable, backgroundColor: UIColor? = nil, selectedBackgroundColor: UIColor? = nil) {
        self.composable = composable
        super.init(backgroundColor: backgroundColor, selectedBackgroundColor: selectedBackgroundColor)
    }

}

open class QCompositionTableCell< Composition: IQComposition > : QBackgroundColorTableCell< QCompositionTableRow< Composition.Composable > > {

    public private(set) var composition: Composition!

    open override class func height(row: Row, spec: IQContainerSpec) -> CGFloat {
        return Composition.height(composable: row.composable, spec: spec)
    }

    open override func setup() {
        super.setup()
        self.composition = Composition(contentView: self.contentView, delegate: self)
    }

    open override func prepareForReuse() {
        self.composition.cleanup()
        super.prepareForReuse()
    }
    
    open override func set(row: Row, spec: IQContainerSpec, animated: Bool) {
        super.set(row: row, spec: spec, animated: animated)
        self.composition.prepare(composable: row.composable, spec: spec, animated: animated)
    }
    
    private func scroll(animated: Bool) {
        guard let row = self.row, let controller = row.section?.controller else { return }
        controller.scroll(row: row, scroll: .middle, animated: animated)
    }

}

extension QCompositionTableCell : IQCompositionDelegate {
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
