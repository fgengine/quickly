//
//  Quickly
//

import UIKit

open class QLabelTableRow: QEdgeInsetsTableRow {

    public var text: IQText
    public var contentAlignment: QLabel.ContentAlignment = .left
    public var padding: CGFloat = 0
    public var numberOfLines: Int = 0
    public var lineBreakMode: NSLineBreakMode = .byWordWrapping

    public init(text: IQText, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero, backgroundColor: UIColor? = nil) {
        self.text = text
        super.init(edgeInsets: edgeInsets, backgroundColor: backgroundColor)
    }

}
