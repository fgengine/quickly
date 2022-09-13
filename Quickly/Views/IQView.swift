//
//  Quickly
//

import UIKit

public enum QViewDirection {
    case vertical
    case horizontal
}

public enum QViewVerticalAlignment {
    case top
    case center
    case bottom
}

public enum QViewHorizontalAlignment {
    case left
    case center
    case right
}

public enum QViewBorder {
    case none
    case manual(width: CGFloat, color: UIColor)
}

public enum QViewCornerRadius {
    case none
    case manual(radius: CGFloat)
    case auto

    public func compute(_ bounds: CGRect) -> CGFloat {
        switch self {
        case .none:
            return 0
        case .manual(let radius):
            return radius
        case .auto:
            let boundsSize = bounds.integral.size
            return ceil(min(boundsSize.width - 1, boundsSize.height - 1) / 2)
        }
    }
}

public struct QViewShadow {

    public var color: UIColor
    public var opacity: CGFloat
    public var radius: CGFloat
    public var offset: CGSize

    public init(color: UIColor, opacity: CGFloat, radius: CGFloat, offset: CGSize) {
        self.color = color
        self.opacity = opacity
        self.radius = radius
        self.offset = offset
    }

}

public protocol IQView : AnyObject {
    
    init()

    func setup()
    
}
