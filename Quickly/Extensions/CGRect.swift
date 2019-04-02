//
//  Quickly
//

public extension CGRect {

    var topLeftPoint: CGPoint {
        get { return CGPoint(x: self.minX, y: self.minY) }
    }
    var topPoint: CGPoint {
        get { return CGPoint(x: self.midX, y: self.minY) }
    }
    var topRightPoint: CGPoint {
        get { return CGPoint(x: self.maxX, y: self.minY) }
    }
    var centerLeftPoint: CGPoint {
        get { return CGPoint(x: self.minX, y: self.midY) }
    }
    var centerPoint: CGPoint {
        get { return CGPoint(x: self.midX, y: self.midY) }
    }
    var centerRightPoint: CGPoint {
        get { return CGPoint(x: self.maxX, y: self.midY) }
    }
    var bottomLeftPoint: CGPoint {
        get { return CGPoint(x: self.minX, y: self.maxY) }
    }
    var bottomPoint: CGPoint {
        get { return CGPoint(x: self.midX, y: self.maxY) }
    }
    var bottomRightPoint: CGPoint {
        get { return CGPoint(x: self.maxX, y: self.maxY) }
    }

    func lerp(_ to: CGRect, progress: CGFloat) -> CGRect {
        return CGRect(
            x: self.origin.x.lerp(to.origin.x, progress: progress),
            y: self.origin.y.lerp(to.origin.y, progress: progress),
            width: self.size.width.lerp(to.size.width, progress: progress),
            height: self.size.height.lerp(to.size.height, progress: progress)
        )
    }
    
}
