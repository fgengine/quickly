//
//  Quickly
//

open class QBackgroundColorCollectionItem : QCollectionItem {

    public var backgroundColor: UIColor?
    public var selectedBackgroundColor: UIColor?

    public init(backgroundColor: UIColor? = nil, selectedBackgroundColor: UIColor? = nil) {
        self.backgroundColor = backgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
        super.init()
    }

}

open class QBackgroundColorCollectionCell< Item: QBackgroundColorCollectionItem > : QCollectionCell< Item > {

    open override func set(item: Item, spec: IQContainerSpec, animated: Bool) {
        super.set(item: item, spec: spec, animated: animated)
        
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
