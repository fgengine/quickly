//
//  Quickly
//

public extension Float {

    public func lerp(_ to: Float, progress: Float) -> Float {
        if abs(self - to) > Float.leastNonzeroMagnitude {
            return ((1 - progress) * self) + (progress * to)
        }
        return self
    }

}
