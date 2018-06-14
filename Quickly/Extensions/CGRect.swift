//
//  Quickly
//

public extension CGRect {

    public var topLeftPoint: CGPoint {
        get { return CGPoint(x: self.minX, y: self.minY) }
    }
    public var topPoint: CGPoint {
        get { return CGPoint(x: self.midX, y: self.minY) }
    }
    public var topRightPoint: CGPoint {
        get { return CGPoint(x: self.maxX, y: self.minY) }
    }
    public var centerLeftPoint: CGPoint {
        get { return CGPoint(x: self.minX, y: self.midY) }
    }
    public var centerPoint: CGPoint {
        get { return CGPoint(x: self.midX, y: self.midY) }
    }
    public var centerRightPoint: CGPoint {
        get { return CGPoint(x: self.maxX, y: self.midY) }
    }
    public var bottomLeftPoint: CGPoint {
        get { return CGPoint(x: self.minX, y: self.maxY) }
    }
    public var bottomPoint: CGPoint {
        get { return CGPoint(x: self.midX, y: self.maxY) }
    }
    public var bottomRightPoint: CGPoint {
        get { return CGPoint(x: self.maxX, y: self.maxY) }
    }

    public func lerp(_ to: CGRect, progress: CGFloat) -> CGRect {
        return CGRect(
            x: self.origin.x.lerp(to.origin.x, progress: progress),
            y: self.origin.y.lerp(to.origin.y, progress: progress),
            width: self.size.width.lerp(to.size.width, progress: progress),
            height: self.size.height.lerp(to.size.height, progress: progress)
        )
    }
    
}
