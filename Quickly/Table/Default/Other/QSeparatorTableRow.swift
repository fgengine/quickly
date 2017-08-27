//
//  Quickly
//

import UIKit

open class QSeparatorTableRow: QEdgeInsetsTableRow {

    public var color: UIColor

    public init(color: UIColor, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero, backgroundColor: UIColor? = nil) {
        self.color = color
        super.init(edgeInsets: edgeInsets, backgroundColor: backgroundColor)
    }

}
