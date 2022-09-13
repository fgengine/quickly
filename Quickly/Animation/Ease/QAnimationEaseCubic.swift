//
//  Quickly
//

import CoreGraphics

public final class QAnimationEaseCubicIn : IQAnimationEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return x * x * x
    }

}

public final class QAnimationEaseCubicOut : IQAnimationEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        let p = x - 1
        return  p * p * p + 1
    }

}

public final class QAnimationEaseCubicInOut : IQAnimationEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x < 1/2 {
            return 4 * x * x * x
        } else {
            let f = ((2 * x) - 2)
            return 1/2 * f * f * f + 1
        }
    }

}
