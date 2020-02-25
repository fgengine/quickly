//
//  Quickly
//

extension QPhotosViewController.PreviewController {
    
    class PhotoItem : QCollectionItem {
        
        public var photo: IQPhotoItem
        public var zoomLevels: UInt

        init(
            photo: IQPhotoItem,
            zoomLevels: UInt
        ) {
            self.photo = photo
            self.zoomLevels = zoomLevels
            super.init(
                canSelect: false,
                canDeselect: false,
                canMove: false
            )
        }
        
    }
    
    class PhotoCell : QCollectionCell< PhotoItem > {
        
        private lazy var _scrollView: ScrollView = {
            let view = ScrollView(frame: self.contentView.bounds)
            view.decelerationRate = UIScrollView.DecelerationRate.fast
            view.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
            view.autoresizesSubviews = true
            self.contentView.addSubview(view)
            return view
        }()

        override class func size(item: Item, layout: UICollectionViewLayout, section: IQCollectionSection, spec: IQContainerSpec) -> CGSize {
            return spec.containerSize
        }

        override func set(item: Item, spec: IQContainerSpec, animated: Bool) {
            super.set(item: item, spec: spec, animated: animated)

            item.photo.add(observer: self)
            if item.photo.isNeedLoad == true || item.photo.isLoading == true {
                item.photo.load()
            } else if item.photo.image != nil {
                self._scrollView.set(item: item)
            }
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            
            if let item = self.item {
                item.photo.remove(observer: self)
            }
        }
        
    }
    
}

// MARK: IQPhotoItemObserver

extension QPhotosViewController.PreviewController.PhotoCell : IQPhotoItemObserver {
    
    func willLoadPhotoItem(_ photoItem: IQPhotoItem) {
    }
    
    func didLoadPhotoItem(_ photoItem: IQPhotoItem) {
        if let item = self.item {
            self._scrollView.set(item: item)
        }
    }
    
}

// MARK: ScrollView

extension QPhotosViewController.PreviewController {
    
    class ScrollView : UIScrollView {
        
        var item: PhotoItem?
        
        private lazy var _contentView: UIView = {
            let view = UIView(frame: self.bounds)
            view.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
            view.autoresizesSubviews = true
            self.addSubview(view)
            return view
        }()
        private lazy var _previewView: UIImageView = {
            let view = UIImageView(frame: self._contentView.bounds)
            view.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
            view.autoresizesSubviews = true
            self._contentView.addSubview(view)
            return view
        }()
        private lazy var _tiledView: TiledView = {
            let view = TiledView(frame: self._contentView.bounds)
            view.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
            view.autoresizesSubviews = true
            self._contentView.addSubview(view)
            return view
        }()
        private lazy var _singleTapGesture: UITapGestureRecognizer = {
            let gesture = UITapGestureRecognizer(target: self, action:#selector(_handleSingleTap))
            gesture.numberOfTapsRequired = 1
            gesture.cancelsTouchesInView = false
            addGestureRecognizer(gesture)
            return gesture
        }()
        private lazy var _doubleTapGesture: UITapGestureRecognizer = {
            let gesture = UITapGestureRecognizer(target: self, action:#selector(_handleDoubleTap))
            gesture.numberOfTapsRequired = 2
            gesture.cancelsTouchesInView = false
            self.addGestureRecognizer(gesture)
            return gesture
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.delegate = self
            
            self._singleTapGesture.require(toFail: self._doubleTapGesture)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func set(item: PhotoItem) {
            let viewSize = self.bounds.size
            let imageSize = item.photo.image!.size
            let scale = min(viewSize.width / imageSize.width, viewSize.height / imageSize.height)
            let zoomScale = self._zoomScaleThatFits(viewSize, source: viewSize)

            self.item = item
            self.minimumZoomScale = zoomScale
            self.maximumZoomScale = zoomScale * CGFloat(item.zoomLevels * item.zoomLevels)
            self.zoomScale = 1
            
            self._contentView.frame = self._centeredRect(CGSize(
                width: imageSize.width * scale,
                height: imageSize.height * scale
            ))
            self._previewView.frame = self._contentView.bounds
            self._previewView.image = item.photo.image
            self._tiledView.photo = item.photo
            self._tiledView.scale = scale
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            self._contentView.frame = self._centeredRect(self._contentView.frame.size)
            
            self._tiledView.contentScaleFactor = 1
        }
        
    }
    
}

// MARK: ScrollView • Private

private extension QPhotosViewController.PreviewController.ScrollView {
    
    @objc
    func _handleSingleTap(_ recognizer: UITapGestureRecognizer) {
    }
    
    @objc
    func _handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        guard let item = self.item else { return }
        if item.zoomLevels > 1 {
            var newScale = self.zoomScale * CGFloat(item.zoomLevels)
            if newScale >= self.maximumZoomScale {
                newScale = self.minimumZoomScale
            }
            self.zoom(
                to: self._zoomRectForScale(newScale, zoomPoint: recognizer.location(in: recognizer.view)),
                animated: true
            )
        }
    }
    
    func _zoomScaleThatFits(_ target: CGSize, source: CGSize) -> CGFloat {
        let widthScale = target.width / source.width
        let heightScale = target.height / source.height
        return (widthScale < heightScale) ? widthScale : heightScale
    }
    
    func _zoomRectForScale(_ scale: CGFloat, zoomPoint: CGPoint) -> CGRect {
        let updatedContentSize = CGSize(
            width: self.contentSize.width / self.zoomScale,
            height: self.contentSize.height / self.zoomScale
        )
        let translatedZoomPoint = CGPoint(
            x: (zoomPoint.x / self.bounds.width) * updatedContentSize.width,
            y: (zoomPoint.y / self.bounds.height) * updatedContentSize.height
        )
        let zoomSize = CGSize(
            width: self.bounds.width / scale,
            height: self.bounds.height / scale
        )
        return CGRect(
            x: translatedZoomPoint.x - zoomSize.width / 2.0,
            y: translatedZoomPoint.y - zoomSize.height / 2.0,
            width: zoomSize.width,
            height: zoomSize.height
        )
    }
    
    func _centeredRect(_ size: CGSize) -> CGRect {
        let boundsSize = self.bounds.size
        return CGRect(
            x: (size.width < boundsSize.width) ? (boundsSize.width - size.width) / 2 : 0,
            y: (size.height < boundsSize.height) ? (boundsSize.height - size.height) / 2 : 0,
            width: size.width,
            height: size.height
        )
    }
    
}

// MARK: ScrollView • UIScrollViewDelegate

extension QPhotosViewController.PreviewController.ScrollView : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self._contentView
    }
    
}

// MARK: TiledView

extension QPhotosViewController.PreviewController {
    
    class TiledView : UIView {
        
        public var photo: IQPhotoItem? {
            didSet {
                self.setNeedsDisplay()
            }
        }
        public var scale: CGFloat = 1 {
            didSet {
                self.setNeedsDisplay()
            }
        }
        
        override class var layerClass: AnyClass {
            return CATiledLayer.self
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            if let layer = self.layer as? CATiledLayer {
                layer.levelsOfDetail = 16
                layer.levelsOfDetailBias = 15
                layer.tileSize = CGSize(width: 1024, height: 1024)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ layer: CALayer, in context: CGContext) {
            if let photo = self.photo {
                photo.draw(context: context, bounds: layer.bounds, scale: self.scale)
            }
        }
        
        deinit {
            self.photo = nil
            self.layer.contents = nil
            self.layer.delegate = nil
            self.layer.removeFromSuperlayer()
        }
        
    }
    
}
