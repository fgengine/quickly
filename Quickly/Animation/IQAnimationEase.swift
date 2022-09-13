//
//  Quickly
//

import CoreGraphics

public protocol IQAnimationEase : AnyObject {

    func perform(_ x: Float) -> Float
    func perform(_ x: Double) -> Double

    func lerp(_ x: Float, from: Float, to: Float) -> Float
    func lerp(_ x: Double, from: Double, to: Double) -> Double
    func lerp(_ x: CGFloat, from: CGFloat, to: CGFloat) -> CGFloat

}

// MARK: Public

public extension IQAnimationEase {

    func perform(_ x: Float) -> Float {
        return Float(self.perform(Double(x)))
    }

    func lerp(_ x: Float, from: Float, to: Float) -> Float {
        return Float(self.lerp(Double(x), from: Double(from), to: Double(to)))
    }

    func lerp(_ x: Double, from: Double, to: Double) -> Double {
        let distance = to - from
        let progress = x / distance
        let ease = self.perform(progress)
        return from.lerp(to, progress: ease)
    }

    func lerp(_ x: CGFloat, from: CGFloat, to: CGFloat) -> CGFloat {
        return CGFloat(self.lerp(x.native, from: from.native, to: to.native))
    }

}
