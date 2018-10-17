//
//  Quickly
//

open class QCompositionCollectionItem< Composable: IQComposable > : QBackgroundColorCollectionItem {

    public var composable: Composable
    public var selectedComposable: Composable?

    public init(
        composable: Composable,
        selectedComposable: Composable? = nil,
        backgroundColor: UIColor? = nil,
        selectedBackgroundColor: UIColor? = nil,
        canSelect: Bool = true,
        canDeselect: Bool = true,
        canMove: Bool = false
    ) {
        self.composable = composable
        self.selectedComposable = selectedComposable
        super.init(
            backgroundColor: backgroundColor,
            selectedBackgroundColor: selectedBackgroundColor,
            canSelect: canSelect,
            canDeselect: canDeselect,
            canMove: canMove
        )
    }

}

open class QCompositionCollectionCell< Composition: IQComposition > : QBackgroundColorCollectionCell< QCompositionCollectionItem< Composition.Composable > > {

    open override var isHighlighted: Bool {
        didSet {
            if let item = self.item, let spec = self.composition.spec {
                self._prepareComposition(item: item, spec: spec, highlighted: self.isHighlighted, selected: self.isSelected, animated: false)
            }
        }
    }
    open override var isSelected: Bool {
        didSet {
            if let item = self.item, let spec = self.composition.spec {
                self._prepareComposition(item: item, spec: spec, highlighted: self.isHighlighted, selected: self.isSelected, animated: false)
            }
        }
    }
    public private(set) var composition: Composition!

    open override class func size(
        item: Item,
        layout: UICollectionViewLayout,
        section: IQCollectionSection,
        spec: IQContainerSpec
    ) -> CGSize {
        return Composition.size(composable: item.composable, spec: spec)
    }

    open override func setup() {
        super.setup()
        self.composition = Composition(contentView: self.contentView, owner: self)
    }

    open override func prepareForReuse() {
        self.composition.cleanup()
        super.prepareForReuse()
    }
    
    open override func set(item: Item, spec: IQContainerSpec, animated: Bool) {
        super.set(item: item, spec: spec, animated: animated)
        self._prepareComposition(item: item, spec: spec, highlighted: self.isHighlighted, selected: self.isSelected, animated: animated)
    }
    
    private func _prepareComposition(item: Item, spec: IQContainerSpec, highlighted: Bool, selected: Bool, animated: Bool) {
        self.composition.prepare(
            composable: self._currentComposable(item: item, highlighted: highlighted, selected: selected),
            spec: spec,
            animated: animated
        )
    }
    
    private func _currentComposable(item: Item, highlighted: Bool, selected: Bool) -> Composition.Composable {
        if selected == true || highlighted == true {
            if let selectedComposable = item.selectedComposable {
                return selectedComposable
            }
        }
        return item.composable
    }
    
    private func _scroll(animated: Bool) {
        guard let item = self.item, let controller = item.section?.controller else { return }
        controller.scroll(item: item, scroll: .centeredVertically, animated: animated)
    }

}

extension QCompositionCollectionCell : IQTextFieldObserver {
    
    open func beginEditing(textField: QTextField) {
        self._scroll(animated: true)
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

extension QCompositionCollectionCell : IQListFieldObserver {
    
    open func beginEditing(listField: QListField) {
        self._scroll(animated: true)
    }
    
    open func select(listField: QListField, row: QListFieldPickerRow) {
    }
    
    open func endEditing(listField: QListField) {
    }
    
}

extension QCompositionCollectionCell : IQDateFieldObserver {
    
    open func beginEditing(dateField: QDateField) {
        self._scroll(animated: true)
    }
    
    open func select(dateField: QDateField, date: Date) {
    }
    
    open func endEditing(dateField: QDateField) {
    }
    
}
