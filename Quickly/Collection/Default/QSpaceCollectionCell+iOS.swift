//
//  Quickly
//

#if os(iOS)

    open class QSpaceCollectionCell< ItemType: QSpaceCollectionItem >: QBackgroundColorCollectionCell< ItemType > {

        open override class func size(
            item: ItemType,
            layout: UICollectionViewLayout,
            section: IQCollectionSection,
            size: CGSize
        ) -> CGSize {
            return item.size
        }

    }

#endif
