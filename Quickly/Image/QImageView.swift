//
//  Quickly
//

import UIKit

open class QImageView: QView, IQImageLoaderTarget {

    public var roundCorners: Bool = false {
        didSet { self.updateCornerRadius() }
    }
    public var source: QImageSource? {
        willSet {
            if self.isDownloading == true {
                if let loader: QImageLoader = self.loader {
                    loader.cancel(self)
                }
            }
            self.isDownloading = false
        }
        didSet {
            if let source: QImageSource = self.source {
                if let image: UIImage = source.image {
                    self.image = image.withRenderingMode(source.renderingMode)
                } else {
                    self.image = nil
                }
                if let url: URL = source.url {
                    if let loader: QImageLoader = self.loader {
                        loader.download(url, filter: self.filter, target: self)
                        self.isDownloading = true
                    }
                }
                self.backgroundColor = source.backgroundColor
                self.tintColor = source.tintColor
            } else {
                self.image = nil
                self.backgroundColor = UIColor.clear
                self.tintColor = nil
            }
        }
    }
    public var filter: IQImageLoaderFilter?
    public private(set) var isDownloading: Bool = false
    public var loader: QImageLoader?
    public private(set) var image: UIImage? {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsDisplay()
        }
    }

    open override var frame: CGRect {
        didSet { self.updateCornerRadius() }
    }
    open override var bounds: CGRect {
        didSet { self.updateCornerRadius() }
    }
    open override var intrinsicContentSize: CGSize {
        get {
            if let source: QImageSource = self.source {
                return source.size(available: CGSize.zero)
            }
            return CGSize.zero
        }
    }

    open override func setup() {
        super.setup()

        self.loader = QImageLoader.shared

        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
    }
    
    open override func draw(_ rect: CGRect) {
        guard let image: UIImage = self.image else {
            return
        }
        if let context: CGContext = UIGraphicsGetCurrentContext() {
            if let tintColor: UIColor = self.tintColor {
                context.setFillColor(tintColor.cgColor)
            }
            var imageRect: CGRect
            if let source: QImageSource = self.source {
                imageRect = source.rect(bounds: self.bounds, image: image)
            } else {
                imageRect = self.bounds
            }
            if let cgImage: CGImage = image.cgImage {
                context.draw(cgImage, in: imageRect)
            }
        }
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if let source: QImageSource = self.source {
            return source.size(available: size)
        }
        return CGSize.zero
    }

    open override func sizeToFit() {
        var frame: CGRect = self.frame
        frame.size = self.sizeThatFits(frame.size)
        self.frame = frame
    }

    private func updateCornerRadius() {
        if self.roundCorners == true {
            let boundsSize: CGSize = self.bounds.integral.size
            self.layer.cornerRadius = ceil(min(boundsSize.width - 1, boundsSize.height - 1) / 2)
        }
    }

    open func imageLoader(_ imageLoader: QImageLoader, cacheImage: UIImage) {
        self.image = cacheImage
        self.isDownloading = false
    }

    open func imageLoader(_ imageLoader: QImageLoader, downloadProgress: Progress) {
    }

    open func imageLoader(_ imageLoader: QImageLoader, downloadImage: UIImage) {
        self.image = downloadImage
        self.isDownloading = false
    }

    open func imageLoader(_ imageLoader: QImageLoader, downloadError: Error) {
        self.isDownloading = false
    }

}

