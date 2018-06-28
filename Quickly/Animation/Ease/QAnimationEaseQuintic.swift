//
//  Quickly
//

public class QAnimationEaseQuinticIn : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        return x * x * x * x * x
    }

}

public class QAnimationEaseQuinticOut : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        let f = (x - 1)
        return f * f * f * f * f + 1
    }

}

public class QAnimationEaseQuinticInOut : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        if x < 1/2 {
            return 16 * x * x * x * x * x
        } else {
            let f = ((2 * x) - 2)
            return  1/2 * f * f * f * f * f + 1
        }
    }

}
