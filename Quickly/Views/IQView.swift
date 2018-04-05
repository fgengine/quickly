//
//  Quickly
//

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
    case manual(width: CGFloat, color: QPlatformColor)
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

public protocol IQView : class {

    func setup()
    
}
