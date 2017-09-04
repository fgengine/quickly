//
//  Quickly
//

import UIKit

open class QTwoLabelTableRow: QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    public var spacing: CGFloat = 0

    public var primaryText: IQText?
    public var primaryContentAlignment: QLabel.ContentAlignment = .left
    public var primaryPadding: CGFloat = 0
    public var primaryNumberOfLines: Int = 0
    public var primaryLineBreakMode: NSLineBreakMode = .byWordWrapping

    public var secondaryText: IQText?
    public var secondaryContentAlignment: QLabel.ContentAlignment = .left
    public var secondaryPadding: CGFloat = 0
    public var secondaryNumberOfLines: Int = 0
    public var secondaryLineBreakMode: NSLineBreakMode = .byWordWrapping

}
