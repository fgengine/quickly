//
//  Quickly
//

public class QAnimationEaseQuarticIn : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        return x * x * x * x
    }

}

public class QAnimationEaseQuarticOut : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        let f = x - 1
        return f * f * f * (1 - x) + 1
    }

}

public class QAnimationEaseQuarticInOut : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        if x < 1/2 {
            return 8 * x * x * x * x
        } else {
            let f = (x - 1)
            return -8 * f * f * f * f + 1
        }
    }

}
