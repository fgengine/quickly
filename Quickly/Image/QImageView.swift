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
                    self.imageView.image = image.withRenderingMode(source.renderingMode)
                }
                if let url: URL = source.url {
                    if let loader: QImageLoader = self.loader {
                        loader.download(url, filter: self.filter, target: self)
                        self.isDownloading = true
                    }
                }
                self.imageView.contentMode = source.scale.toContentMode()
            } else {
                self.imageView.image = nil
            }
            self.invalidateIntrinsicContentSize()
        }
    }
    public var filter: IQImageLoaderFilter?
    public private(set) var isDownloading: Bool = false
    public var loader: QImageLoader?

    public private(set) var imageView: UIImageView!

    open override var frame: CGRect {
        didSet { self.updateCornerRadius() }
    }

    open override var bounds: CGRect {
        didSet { self.updateCornerRadius() }
    }
    
    open override var intrinsicContentSize: CGSize {
        get {
            if let source: QImageSource = self.source {
                return source.size(available: self.bounds.size)
            }
            return CGSize.zero
        }
    }

    open override func setup() {
        super.setup()

        self.loader = QImageLoader.shared
        
        self.backgroundColor = UIColor.clear

        self.imageView = UIImageView(frame: self.bounds)
        self.imageView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.imageView.isUserInteractionEnabled = false
        self.imageView.backgroundColor = UIColor.clear
        self.imageView.contentMode = .scaleAspectFit
        self.addSubview(self.imageView)
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
        self.imageView.image = cacheImage
        self.invalidateIntrinsicContentSize()
        self.isDownloading = false
    }

    open func imageLoader(_ imageLoader: QImageLoader, downloadProgress: Progress) {
    }

    open func imageLoader(_ imageLoader: QImageLoader, downloadImage: UIImage) {
        self.imageView.image = downloadImage
        self.invalidateIntrinsicContentSize()
        self.isDownloading = false
    }

    open func imageLoader(_ imageLoader: QImageLoader, downloadError: Error) {
        self.isDownloading = false
    }

}
