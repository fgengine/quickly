//
//  Quickly
//

open class QSpaceCollectionItem : QBackgroundColorCollectionItem {

    public var size: CGSize

    public init(size: CGSize, backgroundColor: UIColor? = nil) {
        self.size = size
        super.init(
            backgroundColor: backgroundColor,
            canSelect: false
        )
    }

}

open class QSpaceCollectionCell< Item: QSpaceCollectionItem > : QBackgroundColorCollectionCell< Item > {

    open override class func size(
        item: Item,
        layout: UICollectionViewLayout,
        section: IQCollectionSection,
        spec: IQContainerSpec
    ) -> CGSize {
        return item.size
    }

}
