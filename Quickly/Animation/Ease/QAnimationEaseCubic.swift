//
//  Quickly
//

public class QAnimationEaseCubicIn : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        return x * x * x
    }

}

public class QAnimationEaseCubicOut : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        let p = x - 1
        return  p * p * p + 1
    }

}

public class QAnimationEaseCubicInOut : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        if x < 1/2 {
            return 4 * x * x * x
        } else {
            let f = ((2 * x) - 2)
            return 1/2 * f * f * f + 1
        }
    }

}
