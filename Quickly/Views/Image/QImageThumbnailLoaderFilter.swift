//
//  Quickly
//

import UIKit

public class QImageThumbnailLoaderFilter : IQImageLoaderFilter {

    public var size: CGSize
    public var name: String {
        get { return "\(self.size.width)x\(self.size.height)" }
    }
    
    public init(_ size: CGSize) {
        self.size = size
    }
    
    public func apply(_ image: UIImage) -> UIImage? {
        return image.scaleTo(size: self.size)
    }
    
}
