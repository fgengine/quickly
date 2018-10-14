//
//  Quickly
//

open class QBackgroundColorCollectionItem : QCollectionItem {

    public var backgroundColor: UIColor?
    public var selectedBackgroundColor: UIColor?

    public init(
        backgroundColor: UIColor? = nil,
        selectedBackgroundColor: UIColor? = nil,
        canSelect: Bool = true,
        canDeselect: Bool = true,
        canMove: Bool = false
    ) {
        self.backgroundColor = backgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
        super.init(
            canSelect: canSelect,
            canDeselect: canDeselect,
            canMove: canMove
        )
    }

}

open class QBackgroundColorCollectionCell< Item: QBackgroundColorCollectionItem > : QCollectionCell< Item > {
    
    open override var isSelected: Bool {
        didSet { self._applyContentBackgroundColor(selected: self.isSelected, highlighted: self.isHighlighted) }
    }
    open override var isHighlighted: Bool {
        didSet { self._applyContentBackgroundColor(selected: self.isSelected, highlighted: self.isHighlighted) }
    }

    open override func set(item: Item, spec: IQContainerSpec, animated: Bool) {
        super.set(item: item, spec: spec, animated: animated)
        
        self._applyContentBackgroundColor(selected: self.isSelected, highlighted: self.isHighlighted)
    }
    
    private func _applyContentBackgroundColor(selected: Bool, highlighted: Bool) {
        let backgroundColor = self._currentContentBackgroundColor(selected: selected, highlighted: highlighted)
        self.backgroundColor = backgroundColor
        self.contentView.backgroundColor = backgroundColor
    }
    
    private func _currentContentBackgroundColor(selected: Bool, highlighted: Bool) -> UIColor? {
        guard let item = self.item else { return nil }
        if let selectedBackgroundColor = item.selectedBackgroundColor {
            if selected == true || highlighted == true {
                return selectedBackgroundColor
            }
        }
        return item.backgroundColor
    }

}
