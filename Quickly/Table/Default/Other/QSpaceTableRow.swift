//
//  Quickly
//

import UIKit

open class QSpaceTableRow: QColorTableRow {

    public var size: CGFloat

    public init(size: CGFloat, backgroundColor: UIColor? = nil) {
        self.size = size
        super.init(backgroundColor: backgroundColor)
    }

}
