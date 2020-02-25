//
//  Quickly
//

public extension CGPoint {
    
    func wrap() -> CGPoint {
        return CGPoint(
            x: self.y,
            y: self.x
        )
    }

    func distance(to: CGPoint) -> CGFloat {
        return sqrt(pow(to.x - self.x, 2) + pow(to.y - self.y, 2))
    }

    func length() -> CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }

    func lerp(_ to: CGPoint, progress: CGFloat) -> CGPoint {
        return CGPoint(
            x: self.x.lerp(to.x, progress: progress),
            y: self.y.lerp(to.y, progress: progress)
        )
    }
    
}
