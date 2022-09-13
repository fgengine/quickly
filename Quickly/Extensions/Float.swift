//
//  Quickly
//

import Foundation

public extension Float {
    
    var degreesToRadians: Self {
        get { return self * .pi / 180 }
    }
    
    var radiansToDegrees: Self {
        get { return self * 180 / .pi }
    }
    
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
