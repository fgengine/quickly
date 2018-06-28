//
//  Quickly
//

public extension Double {

    public func lerp(_ to: Double, progress: Double) -> Double {
        return ((1 - progress) * self) + (progress * to)
    }

}
