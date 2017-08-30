//
//  Quickly
//

import UIKit

public extension CGRect {

    public func lerp(_ to: CGRect, progress: CGFloat) -> CGRect {
        return CGRect(
            x: self.origin.x.lerp(to.origin.x, progress: progress),
            y: self.origin.y.lerp(to.origin.y, progress: progress),
            width: self.size.width.lerp(to.size.width, progress: progress),
            height: self.size.height.lerp(to.size.height, progress: progress)
        )
    }
    
}
