//
//  Quickly
//

public class QAnimationEaseSineIn : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        return (sin((x - 1) * Double.pi / 2) ) + 1
    }

}

public class QAnimationEaseSineOut : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        return sin(x * Double.pi / 2)
    }

}

public class QAnimationEaseSineInOut : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        return 1 / 2 * (1 - cos(x * Double.pi))
    }

}
