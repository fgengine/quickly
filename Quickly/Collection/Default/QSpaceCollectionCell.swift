//
//  Quickly
//

open class QSpaceCollectionItem : QBackgroundColorCollectionItem {

    public var size: CGSize

    public init(size: CGSize) {
        self.size = size
        super.init()
    }

}

open class QSpaceCollectionCell< ItemType: QSpaceCollectionItem > : QBackgroundColorCollectionCell< ItemType > {

    open override class func size(
        item: ItemType,
        layout: UICollectionViewLayout,
        section: IQCollectionSection,
        size: CGSize
    ) -> CGSize {
        return item.size
    }

}
