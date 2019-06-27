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
    
    func aspectFit(size: CGSize) -> CGRect {
        let iw = floor(size.width)
        let ih = floor(size.height)
        let bw = floor(self.size.width)
        let bh = floor(self.size.height)
        let fw = bw / iw
        let fh = bh / ih
        let sc = (fw < fh) ? fw : fh
        let rw = iw * sc
        let rh = ih * sc
        let rx = (bw - rw) / 2
        let ry = (bh - rh) / 2
        return CGRect(
            x: self.origin.x + rx,
            y: self.origin.y + ry,
            width: rw,
            height: rh
        )
    }
    
    func aspectFill(size: CGSize) -> CGRect {
        let iw = floor(size.width)
        let ih = floor(size.height)
        let bw = floor(self.size.width)
        let bh = floor(self.size.height)
        let fw = bw / iw
        let fh = bh / ih
        let sc = (fw > fh) ? fw : fh
        let rw = iw * sc
        let rh = ih * sc
        let rx = (bw - rw) / 2
        let ry = (bh - rh) / 2
        return CGRect(
            x: self.origin.x + rx,
            y: self.origin.y + ry,
            width: rw,
            height: rh
        )
    }
    
}
