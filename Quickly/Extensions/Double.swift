//
//  Quickly
//

public extension Double {
    
    var degreesToRadians: Self {
        get { return self * .pi / 180 }
    }
    
    var radiansToDegrees: Self {
        get { return self * 180 / .pi }
    }
    
    func ceil() -> Double {
        return Foundation.ceil(self)
    }

    func lerp(_ to: Double, progress: Double) -> Double {
        if abs(self - to) > Double.leastNonzeroMagnitude {
            return ((1 - progress) * self) + (progress * to)
        }
        return self
    }

}
