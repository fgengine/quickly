//
//  Quickly
//

public extension CGFloat {
    
    func ceil() -> CGFloat {
        return CGFloat(self.native.ceil())
    }

    func lerp(_ to: CGFloat, progress: CGFloat) -> CGFloat {
        return CGFloat(self.native.lerp(to.native, progress: progress.native))
    }

}
