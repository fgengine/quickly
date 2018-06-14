//
//  Quickly
//

public extension CGPoint {

    public func distance(to: CGPoint) -> CGFloat {
        return sqrt(pow(to.x - self.x, 2) + pow(to.y - self.y, 2))
    }

    public func length() -> CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }

    public func lerp(_ to: CGPoint, progress: CGFloat) -> CGPoint {
        return CGPoint(
            x: self.x.lerp(to.x, progress: progress),
            y: self.y.lerp(to.y, progress: progress)
        )
    }
    
}
