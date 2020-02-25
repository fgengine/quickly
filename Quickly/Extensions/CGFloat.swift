//
//  Quickly
//

public extension CGFloat {
    
    var degreesToRadians: Self {
        get { return CGFloat(self.native.degreesToRadians) }
    }
    
    var radiansToDegrees: Self {
        get { return CGFloat(self.native.radiansToDegrees) }
    }
    
    func ceil() -> CGFloat {
        return CGFloat(self.native.ceil())
    }

    func lerp(_ to: CGFloat, progress: CGFloat) -> CGFloat {
        return CGFloat(self.native.lerp(to.native, progress: progress.native))
    }

}
