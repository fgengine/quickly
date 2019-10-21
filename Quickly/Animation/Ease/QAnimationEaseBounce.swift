//
//  Quickly
//

public final class QAnimationEaseBounceIn : IQAnimationEase {

    private let easeOut: QAnimationEaseBounceOut

    public init() {
        self.easeOut = QAnimationEaseBounceOut()
    }

    public func perform(_ x: Double) -> Double {
        return 1 - self.easeOut.perform(1 - x)
    }

}

public final class QAnimationEaseBounceOut : IQAnimationEase {

    public func perform(_ x: Double) -> Double {
        if x < 4 / 11 {
            return (121 * x * x) / 16
        } else if x < 8 / 11 {
            let f = (363 / 40) * x * x
            let g = (99 / 10) * x
            return f - g + (17 / 5)
        } else if x < 9 / 10 {
            let f = (4356 / 361) * x * x
            let g = (35442 / 1805) * x
            return  f - g + (16061 / 1805)
        } else {
            let f = (54 / 5) * x * x
            return f - ((513 / 25) * x) + 268 / 25
        }
    }

}

public final class QAnimationEaseBounceInOut : IQAnimationEase {

    private let easeIn: QAnimationEaseBounceIn
    private let easeOut: QAnimationEaseBounceOut

    public init() {
        self.easeIn = QAnimationEaseBounceIn()
        self.easeOut = QAnimationEaseBounceOut()
    }

    public func perform(_ x: Double) -> Double {
        if x < 1 / 2 {
            return 1 / 2 * self.easeIn.perform(x * 2)
        } else {
            let f = self.easeOut.perform(x * 2 - 1) + 1
            return 1 / 2 * f
        }
    }

}
