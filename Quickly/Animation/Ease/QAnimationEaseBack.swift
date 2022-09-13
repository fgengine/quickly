//
//  Quickly
//

import CoreGraphics

public final class QAnimationEaseBackIn : IQAnimationEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return x * x * x - x * sin(x * Double.pi)
    }

}

public final class QAnimationEaseBackOut : IQAnimationEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        let f = (1 - x)
        return 1 - (f * f * f - f * sin(f * Double.pi))
    }

}

public final class QAnimationEaseBackInOut : IQAnimationEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x < 1 / 2 {
            let f = 2 * x
            return 1 / 2 * (f * f * f - f * sin(f * Double.pi))
        } else {
            let f = 1 - (2 * x - 1)
            let g = sin(f * Double.pi)
            let h = (f * f * f - f * g)
            return 1 / 2 * (1 - h) + 1 / 2
        }
    }

}
