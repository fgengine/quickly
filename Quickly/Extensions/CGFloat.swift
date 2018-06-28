//
//  Quickly
//

public extension CGFloat {

    public func lerp(_ to: CGFloat, progress: CGFloat) -> CGFloat {
        return CGFloat(self.native.lerp(to.native, progress: progress.native))
    }

}
