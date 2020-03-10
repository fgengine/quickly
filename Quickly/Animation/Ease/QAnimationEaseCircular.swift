//
//  Quickly
//

public final class QAnimationEaseCircularIn : IQAnimationEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return 1 - sqrt(1 - (x * x))
    }

}

public final class QAnimationEaseCircularOut : IQAnimationEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        return sqrt((2 - x) * x)
    }

}

public final class QAnimationEaseCircularInOut : IQAnimationEase {
    
    public init() {
    }

    public func perform(_ x: Double) -> Double {
        if x < 1 / 2 {
            let h = 1 - sqrt(1 - 4 * (x * x))
            return 1 / 2 * h
        } else {
            let f = -((2 * x) - 3) * ((2 * x) - 1)
            let g = sqrt( f )
            return 1 / 2 * ( g + 1 )
        }
    }

}
