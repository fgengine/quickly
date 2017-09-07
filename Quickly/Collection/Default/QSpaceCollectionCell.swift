//
//  Quickly
//

import UIKit

open class QSpaceCollectionCell< ItemType: QSpaceCollectionItem >: QBackgroundColorCollectionCell< ItemType > {

    open override class func size(item: ItemType, size: CGSize) -> CGSize {
        return item.size
    }

}

