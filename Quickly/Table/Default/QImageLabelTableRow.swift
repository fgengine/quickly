//
//  Quickly
//

import UIKit

open class QImageLabelTableRow: QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    public var spacing: CGFloat = 0

    public var imageSource: QImageSource?
    public var imageRoundCorners: Bool = false

    public var text: IQText?
    public var textContentAlignment: QLabel.ContentAlignment = .left
    public var textPadding: CGFloat = 0
    public var textNumberOfLines: Int = 0
    public var textLineBreakMode: NSLineBreakMode = .byWordWrapping

}
