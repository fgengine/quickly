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
    internal var currentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self.currentConstraints) }
        didSet { self.addConstraints(self.currentConstraints) }
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
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
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

    open override func updateConstraints() {
        var currentConstraints: [NSLayoutConstraint] = []
        currentConstraints.append(self.imageView.topLayout == self.topLayout)
        currentConstraints.append(self.imageView.leadingLayout == self.leadingLayout)
        currentConstraints.append(self.imageView.trailingLayout == self.trailingLayout)
        currentConstraints.append(self.imageView.bottomLayout == self.bottomLayout)
        self.currentConstraints = currentConstraints

        super.updateConstraints()
    }

}
