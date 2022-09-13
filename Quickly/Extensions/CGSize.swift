//
//  Quickly
//

import CoreGraphics

public extension CGSize {
    
    func wrap() -> CGSize {
        return CGSize(
            width: self.height,
            height: self.width
        )
    }
    
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
    
    func aspectFit(size: CGSize) -> CGSize {
        let iw = floor(self.width)
        let ih = floor(self.height)
        let bw = floor(size.width)
        let bh = floor(size.height)
        let fw = bw / iw
        let fh = bh / ih
        let sc = (fw < fh) ? fw : fh
        let rw = iw * sc
        let rh = ih * sc
        return CGSize(
            width: rw,
            height: rh
        )
    }
    
    func aspectFill(size: CGSize) -> CGSize {
        let iw = floor(self.width)
        let ih = floor(self.height)
        let bw = floor(size.width)
        let bh = floor(size.height)
        let fw = bw / iw
        let fh = bh / ih
        let sc = (fw > fh) ? fw : fh
        let rw = iw * sc
        let rh = ih * sc
        return CGSize(
            width: rw,
            height: rh
        )
    }
    
}
