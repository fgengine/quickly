//
//  Quickly
//

import UIKit

open class QEdgeInsetsTableRow: QColorTableRow {

    public var edgeInsets: UIEdgeInsets

    public init(edgeInsets: UIEdgeInsets = UIEdgeInsets.zero, backgroundColor: UIColor? = nil) {
        self.edgeInsets = edgeInsets
        super.init(backgroundColor: backgroundColor)
    }

}
