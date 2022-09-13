//
//  Quickly
//

import UIKit

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
    
    open override var isHighlighted: Bool {
        didSet {
            if let item = self.item {
                self._applyContentBackgroundColor(item: item)
            }
        }
    }
    open override var isSelected: Bool {
        didSet {
            if let item = self.item {
                self._applyContentBackgroundColor(item: item)
            }
        }
    }

    open override func set(item: Item, spec: IQContainerSpec, animated: Bool) {
        super.set(item: item, spec: spec, animated: animated)
        self._applyContentBackgroundColor(item: item)
    }
    
    private func _applyContentBackgroundColor(item: Item) {
        self._applyContentBackgroundColor(item: item, highlighted: self.isHighlighted, selected: self.isSelected)
    }
    
    private func _applyContentBackgroundColor(item: Item, highlighted: Bool, selected: Bool) {
        let backgroundColor = self._currentContentBackgroundColor(item: item, highlighted: highlighted, selected: selected)
        self.backgroundColor = backgroundColor
        self.contentView.backgroundColor = backgroundColor
    }
    
    private func _currentContentBackgroundColor(item: Item, highlighted: Bool, selected: Bool) -> UIColor? {
        if let selectedBackgroundColor = item.selectedBackgroundColor {
            if selected == true || highlighted == true {
                return selectedBackgroundColor
            }
        }
        return item.backgroundColor
    }

}
