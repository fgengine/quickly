//
//  Quickly
//

import UIKit

open class QImageView: QView {

    public var source: QImageSource? {
        didSet {
            if let source: QImageSource = self.source {
                self.imageView.image = source.image
            } else {
                self.imageView.image = nil
            }
        }
    }

    public private(set) var imageView: UIImageView!
    
    open override var intrinsicContentSize: CGSize {
        get {
            return self.imageView.intrinsicContentSize
        }
    }

    open override func setup() {
        super.setup()
        
        self.backgroundColor = UIColor.clear

        self.imageView = UIImageView(frame: self.bounds)
        self.imageView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.imageView.isUserInteractionEnabled = false
        self.imageView.backgroundColor = UIColor.clear
        self.imageView.contentMode = .scaleAspectFit
        self.addSubview(self.imageView)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.imageView.sizeThatFits(size)
    }

    open override func sizeToFit() {
        return self.imageView.sizeToFit()
    }

}
