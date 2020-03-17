//
//  Quickly
//

extension QPhotosViewController.ThumbnailController {
    
    class PhotoItem : QCollectionItem {
        
        public var photo: IQPhotoItem
        public var selectedAlpha: CGFloat
        public var selectedBorderWidth: CGFloat
        public var selectedBorderColor: UIColor?
        public var unselectedAlpha: CGFloat
        public var unselectedBorderWidth: CGFloat
        public var unselectedBorderColor: UIColor?

        init(
            photo: IQPhotoItem,
            selectedAlpha: CGFloat,
            selectedBorderWidth: CGFloat,
            selectedBorderColor: UIColor?,
            unselectedAlpha: CGFloat,
            unselectedBorderWidth: CGFloat,
            unselectedBorderColor: UIColor?
        ) {
            self.photo = photo
            self.selectedAlpha = selectedAlpha
            self.selectedBorderWidth = selectedBorderWidth
            self.selectedBorderColor = selectedBorderColor
            self.unselectedAlpha = unselectedAlpha
            self.unselectedBorderWidth = unselectedBorderWidth
            self.unselectedBorderColor = unselectedBorderColor
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
                    self._applySelected(item: item)
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
            self._applySelected(item: item)
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

    func _applySelected(item: Item) {
        self._applySelected(item: item, selected: self.isSelected)
    }

    func _applySelected(item: Item, selected: Bool) {
        let borderWidth = self._borderWidth(item: item, selected: selected)
        let borderColor = self._borderColor(item: item, selected: selected)
        let alpha = self._alpha(item: item, selected: selected)
        if let borderColor = borderColor {
            self._imageView.layer.borderWidth = borderWidth
            self._imageView.layer.borderColor = borderColor.cgColor
        } else {
            self._imageView.layer.borderWidth = 0
            self._imageView.layer.borderColor = nil
        }
        self._imageView.alpha = alpha
    }

    func _borderWidth(item: Item, selected: Bool) -> CGFloat {
        if selected == true {
            return item.selectedBorderWidth
        }
        return item.unselectedBorderWidth
    }

    func _borderColor(item: Item, selected: Bool) -> UIColor? {
        if selected == true {
            return item.selectedBorderColor
        }
        return item.unselectedBorderColor
    }

    func _alpha(item: Item, selected: Bool) -> CGFloat {
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
