//
//  Quickly
//

public extension Float {
    
    func ceil() -> Float {
        return Foundation.ceil(self)
    }

    func lerp(_ to: Float, progress: Float) -> Float {
        if abs(self - to) > Float.leastNonzeroMagnitude {
            return ((1 - progress) * self) + (progress * to)
        }
        return self
    }

}
