//
//  Quickly
//

public final class QAnimationEaseQuadraticIn : IQAnimationEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return x * x
    }

}

public final class QAnimationEaseQuadraticOut : IQAnimationEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return -(x * (x - 2))
    }

}

public final class QAnimationEaseQuadraticInOut : IQAnimationEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x < 1 / 2 {
            return 2 * x * x
        } else {
            return (-2 * x * x) + (4 * x) - 1
        }
    }

}
