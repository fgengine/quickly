//
//  Quickly
//

public extension CGSize {

    public func lerp(_ to: CGSize, progress: CGFloat) -> CGSize {
        return CGSize(
            width: self.width.lerp(to.width, progress: progress),
            height: self.height.lerp(to.height, progress: progress)
        )
    }

    public func aspectFit(bounds: CGRect) -> CGRect {
        let iw: CGFloat = floor(self.width)
        let ih: CGFloat = floor(self.height)
        let bw: CGFloat = floor(bounds.size.width)
        let bh: CGFloat = floor(bounds.size.height)
        let fw: CGFloat = bw / iw
        let fh: CGFloat = bh / ih
        let sc: CGFloat = (fw < fh) ? fw : fh
        let rw: CGFloat = iw * sc
        let rh: CGFloat = ih * sc
        let rx: CGFloat = (bw - rw) * 0.5
        let ry: CGFloat = (bh - rh) * 0.5
        return CGRect(
            x: bounds.origin.x + rx,
            y: bounds.origin.y + ry,
            width: rw,
            height: rh
        )
    }

    public func aspectFill(bounds: CGRect) -> CGRect {
        let iw: CGFloat = floor(self.width)
        let ih: CGFloat = floor(self.height)
        let bw: CGFloat = floor(bounds.size.width)
        let bh: CGFloat = floor(bounds.size.height)
        let fw: CGFloat = bw / iw
        let fh: CGFloat = bh / ih
        let sc: CGFloat = (fw > fh) ? fw : fh
        let rw: CGFloat = iw * sc
        let rh: CGFloat = ih * sc
        let rx: CGFloat = (bw - rw) * 0.5
        let ry: CGFloat = (bh - rh) * 0.5
        return CGRect(
            x: bounds.origin.x + rx,
            y: bounds.origin.y + ry,
            width: rw,
            height: rh
        )
    }
    
}
