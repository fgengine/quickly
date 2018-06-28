//
//  Quickly
//

public class QAnimationEaseQuadraticIn : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        return x * x
    }

}

public class QAnimationEaseQuadraticOut : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        return -(x * (x - 2))
    }

}

public class QAnimationEaseQuadraticInOut : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        if x < 1 / 2 {
            return 2 * x * x
        } else {
            return (-2 * x * x) + (4 * x) - 1
        }
    }

}
