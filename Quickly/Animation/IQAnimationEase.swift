//
//  Quickly
//

public protocol IQAnimationEase : class {

    func perform(_ x: Float) -> Float
    func perform(_ x: Double) -> Double

    func lerp(_ x: Float, from: Float, to: Float) -> Float
    func lerp(_ x: Double, from: Double, to: Double) -> Double
    func lerp(_ x: CGFloat, from: CGFloat, to: CGFloat) -> CGFloat

}

extension IQAnimationEase {

    public func perform(_ x: Float) -> Float {
        return Float(self.perform(Double(x)))
    }

    public func lerp(_ x: Float, from: Float, to: Float) -> Float {
        return Float(self.lerp(Double(x), from: Double(from), to: Double(to)))
    }

    public func lerp(_ x: Double, from: Double, to: Double) -> Double {
        let distance = to - from
        let progress = x / distance
        let ease = self.perform(progress)
        return from.lerp(to, progress: ease)
    }

    public func lerp(_ x: CGFloat, from: CGFloat, to: CGFloat) -> CGFloat {
        return CGFloat(self.lerp(x.native, from: from.native, to: to.native))
    }

}
