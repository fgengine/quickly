//
//  Quickly
//

import CoreGraphics

public final class QAnimationEaseSineIn : IQAnimationEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return (sin((x - 1) * Double.pi / 2) ) + 1
    }

}

public final class QAnimationEaseSineOut : IQAnimationEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return sin(x * Double.pi / 2)
    }

}

public final class QAnimationEaseSineInOut : IQAnimationEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return 1 / 2 * (1 - cos(x * Double.pi))
    }

}
