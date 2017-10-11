//
//  Quickly
//

public extension CGFloat {

    public func lerp(_ to: CGFloat, progress: CGFloat) -> CGFloat {
        return ((1 - progress) * self) + (progress * to)
    }

}
