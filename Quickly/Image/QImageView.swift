//
//  Quickly
//

import UIKit

open class QImageView: QView {

    public var roundCorners: Bool = false {
        didSet { self.updateCornerRadius() }
    }
    public var source: QImageSource? {
        didSet {
            guard let source: QImageSource = self.source, let image: UIImage = source.image else {
                self.imageView.image = nil
                return
            }
            self.imageView.image = image.withRenderingMode(source.renderingMode)
            self.imageView.contentMode = source.scale.toContentMode()
        }
    }

    public private(set) var imageView: UIImageView!

    open override var frame: CGRect {
        didSet { self.updateCornerRadius() }
    }

    open override var bounds: CGRect {
        didSet { self.updateCornerRadius() }
    }
    
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

    private func updateCornerRadius() {
        if self.roundCorners == true {
            let boundsSize: CGSize = self.bounds.integral.size
            self.layer.cornerRadius = ceil(min(boundsSize.width - 1, boundsSize.height - 1) / 2)
        }
    }

}
