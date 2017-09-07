//
//  Quickly
//

import UIKit

open class QSeparatorCollectionItem: QBackgroundColorCollectionItem {

    public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    public var axis: UILayoutConstraintAxis
    public var color: UIColor

    public init(axis: UILayoutConstraintAxis, color: UIColor) {
        self.axis = axis
        self.color = color
        super.init()
    }


}
