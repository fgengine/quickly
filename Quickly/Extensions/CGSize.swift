//
//  Quickly
//

public extension CGSize {
    
    func ceil() -> CGSize {
        return CGSize(
            width: self.width.ceil(),
            height: self.height.ceil()
        )
    }

    func lerp(_ to: CGSize, progress: CGFloat) -> CGSize {
        return CGSize(
            width: self.width.lerp(to.width, progress: progress),
            height: self.height.lerp(to.height, progress: progress)
        )
    }

    func aspectFit(bounds: CGRect) -> CGRect {
        let iw = floor(self.width)
        let ih = floor(self.height)
        let bw = floor(bounds.size.width)
        let bh = floor(bounds.size.height)
        let fw = bw / iw
        let fh = bh / ih
        let sc = (fw < fh) ? fw : fh
        let rw = iw * sc
        let rh = ih * sc
        let rx = (bw - rw) / 2
        let ry = (bh - rh) / 2
        return CGRect(
            x: bounds.origin.x + rx,
            y: bounds.origin.y + ry,
            width: rw,
            height: rh
        )
    }

    func aspectFill(bounds: CGRect) -> CGRect {
        let iw = floor(self.width)
        let ih = floor(self.height)
        let bw = floor(bounds.size.width)
        let bh = floor(bounds.size.height)
        let fw = bw / iw
        let fh = bh / ih
        let sc = (fw > fh) ? fw : fh
        let rw = iw * sc
        let rh = ih * sc
        let rx = (bw - rw) / 2
        let ry = (bh - rh) / 2
        return CGRect(
            x: bounds.origin.x + rx,
            y: bounds.origin.y + ry,
            width: rw,
            height: rh
        )
    }
    
}
