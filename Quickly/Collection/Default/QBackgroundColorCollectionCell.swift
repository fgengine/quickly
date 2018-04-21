//
//  Quickly
//

open class QBackgroundColorCollectionItem : QCollectionItem {

    public var backgroundColor: UIColor?
    public var selectedBackgroundColor: UIColor?

}

open class QBackgroundColorCollectionCell< ItemType: QBackgroundColorCollectionItem >: QCollectionCell< ItemType > {

    open override func set(item: ItemType, animated: Bool) {
        super.set(item: item, animated: animated)
        
        if let backgroundColor = item.backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let selectedBackgroundColor = item.selectedBackgroundColor {
            let view = UIView(frame: self.bounds)
            view.backgroundColor = selectedBackgroundColor
            self.selectedBackgroundView = view
        } else {
            self.selectedBackgroundView = nil
        }
    }

}
