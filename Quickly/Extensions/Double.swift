//
//  Quickly
//

public extension Double {
    
    public func ceil() -> Double {
        return Foundation.ceil(self)
    }

    public func lerp(_ to: Double, progress: Double) -> Double {
        if abs(self - to) > Double.leastNonzeroMagnitude {
            return ((1 - progress) * self) + (progress * to)
        }
        return self
    }

}
