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
            return self.imageView.intrinsicContentSize
        }
    }

    open override func setup() {
        super.setup()

        self.loader = QImageLoader.shared
        
        self.backgroundColor = UIColor.clear

        self.imageView = UIImageView(frame: self.bounds)
        self.imageView.translatesAutoresizingMaskIntoConstraints = true
        self.imageView.isUserInteractionEnabled = false
        self.imageView.backgroundColor = UIColor.clear
        self.imageView.contentMode = .scaleAspectFit
        self.addSubview(self.imageView)

        self.addConstraints([
            self.imageView.topLayout == self.topLayout,
            self.imageView.leadingLayout == self.leadingLayout,
            self.imageView.trailingLayout == self.trailingLayout,
            self.imageView.bottomLayout == self.bottomLayout
        ])
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

    open func imageLoader(_ imageLoader: QImageLoader, cacheImage: UIImage) {
        self.imageView.image = cacheImage
        self.isDownloading = false
    }

    open func imageLoader(_ imageLoader: QImageLoader, downloadProgress: Progress) {
    }

    open func imageLoader(_ imageLoader: QImageLoader, downloadImage: UIImage) {
        self.imageView.image = downloadImage
        self.isDownloading = false
    }

    open func imageLoader(_ imageLoader: QImageLoader, downloadError: Error) {
        self.isDownloading = false
    }

}
