//
//  Quickly
//

import UIKit

open class QButtonTableRow: QBackgroundColorTableRow {

    public var height: CGFloat = 44
    public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero

    public var contentHorizontalAlignment: UIControlContentHorizontalAlignment = .center
    public var contentVerticalAlignment: UIControlContentVerticalAlignment = .center
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    public var imagePosition: QButtonImagePosition = .left
    public var imageInsets: UIEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    public var textInsets: UIEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    public var normalStyle: QButtonStyle?
    public var highlightedStyle: QButtonStyle?
    public var disabledStyle: QButtonStyle?
    public var selectedStyle: QButtonStyle?
    public var selectedHighlightedStyle: QButtonStyle?
    public var selectedDisabledStyle: QButtonStyle?
    public var spinnerPosition: QButtonSpinnerPosition = .fill
    public var spinnerView: QSpinnerView?

    public var isSpinnerAnimating: Bool = false

}
