//
//  Quickly
//

public extension Float {

    public func lerp(_ to: Float, progress: Float) -> Float {
        return ((1 - progress) * self) + (progress * to)
    }

}
