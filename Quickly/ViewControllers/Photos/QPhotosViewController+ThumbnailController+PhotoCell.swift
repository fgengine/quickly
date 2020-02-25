//
//  Quickly
//

extension QPhotosViewController.ThumbnailController {
    
    class PhotoItem : QCollectionItem {
        
        public var photo: IQPhotoItem
        public var selectedAlpha: CGFloat
        public var unselectedAlpha: CGFloat

        init(
            photo: IQPhotoItem,
            selectedAlpha: CGFloat = 1,
            unselectedAlpha: CGFloat = 0.8
        ) {
            self.photo = photo
            self.selectedAlpha = selectedAlpha
            self.unselectedAlpha = unselectedAlpha
            super.init(
                canSelect: true,
                canDeselect: false,
                canMove: false
            )
        }
        
    }
    
    class PhotoCell : QCollectionCell< PhotoItem > {
        
        open override var isSelected: Bool {
            didSet {
                if let item = self.item {
                    self._applyContentAlpha(item: item)
                }
            }
        }
        private lazy var _imageView: UIImageView = {
            let view = UIImageView(frame: self.contentView.bounds)
            view.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
            view.autoresizesSubviews = true
            view.contentMode = .scaleAspectFit
            view.clipsToBounds = true
            self.contentView.addSubview(view)
            return view
        }()

        override class func size(item: Item, layout: UICollectionViewLayout, section: IQCollectionSection, spec: IQContainerSpec) -> CGSize {
            let availableHeight = spec.containerSize.height
            return item.photo.size.aspectFit(
                size: CGSize(
                    width: availableHeight,
                    height: availableHeight
                )
            )
        }

        override func set(item: Item, spec: IQContainerSpec, animated: Bool) {
            super.set(item: item, spec: spec, animated: animated)

            item.photo.add(observer: self)
            if item.photo.isNeedLoad == true || item.photo.isLoading == true {
                item.photo.load()
            } else if let image = item.photo.image {
                self._imageView.image = image
            }
            self._applyContentAlpha(item: item)
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            
            if let item = self.item {
                item.photo.remove(observer: self)
            }
        }
        
    }
    
}

// MARK: Private

private extension QPhotosViewController.ThumbnailController.PhotoCell {

    func _applyContentAlpha(item: Item) {
        self._applyContentAlpha(item: item, selected: self.isSelected)
    }

    func _applyContentAlpha(item: Item, selected: Bool) {
        let alpha = self._currentContentAlpha(item: item, selected: selected)
        self._imageView.alpha = alpha
    }

    func _currentContentAlpha(item: Item, selected: Bool) -> CGFloat {
        if selected == true {
            return item.selectedAlpha
        }
        return item.unselectedAlpha
    }
    
}

// MARK: IQPhotoItemObserver

extension QPhotosViewController.ThumbnailController.PhotoCell : IQPhotoItemObserver {
    
    func willLoadPhotoItem(_ photoItem: IQPhotoItem) {
    }
    
    func didLoadPhotoItem(_ photoItem: IQPhotoItem) {
        if let image = photoItem.image {
            self._imageView.image = image
        }
    }
    
}
