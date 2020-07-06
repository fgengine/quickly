//
//  Quickly
//

extension QPhotosViewController {
    
    class PreviewController : QCollectionController {
        
        var didSelectPhoto: (_ photo: IQPhotoItem) -> Void
        
        private var _photos: [IQPhotoItem]
        private var _selectedPhoto: IQPhotoItem?
        private var _items: [PhotoItem]
        
        init(
            photos: [IQPhotoItem],
            selectedPhoto: IQPhotoItem?,
            didSelectPhoto: @escaping (_ photo: IQPhotoItem) -> Void
        ) {
            self.didSelectPhoto = didSelectPhoto
            self._photos = photos
            self._selectedPhoto = selectedPhoto
            self._items = []
            super.init(cells: [
                PhotoCell.self
            ])
        }
        
        override func rebuild() {
            self._items = self._photos.compactMap({
                return PhotoItem(photo: $0, zoomLevels: 2)
            })
            self.sections = [
                QCollectionSection(items: self._items)
            ]
            super.rebuild()
        }
        
        func set(photos: [IQPhotoItem], selectedPhoto: IQPhotoItem?) {
            self._photos = photos
            self._selectedPhoto = selectedPhoto
            self.rebuild()
            if let selectedPhoto = selectedPhoto {
                if let item = self._items.first(where: { return $0.photo === selectedPhoto }) {
                    self.scroll(item: item, scroll: .centeredHorizontally, animated: false)
                }
            }
        }
        
        func set(selectedPhoto: IQPhotoItem?) {
            self._selectedPhoto = selectedPhoto
            if let selectedPhoto = selectedPhoto {
                if let item = self._items.first(where: { return $0.photo === selectedPhoto }) {
                    self.scroll(item: item, scroll: .centeredHorizontally, animated: true)
                }
            }
        }
        
    }
    
}

// MARK: Private

private extension QPhotosViewController.PreviewController {
    
    func _updateScroll() {
        let index: Int
        if let collectionView = self.collectionView {
            let bounds = collectionView.bounds
            if bounds.width > CGFloat.leastNonzeroMagnitude {
                index = Int(round(bounds.origin.x / bounds.width))
            } else {
                index = 0
            }
        } else {
            index = 0
        }
        if self._photos.count > index {
            let selectedPhoto = self._photos[index]
            if self._selectedPhoto !== selectedPhoto {
                self._selectedPhoto = selectedPhoto
                self.didSelectPhoto(selectedPhoto)
            }
        }
    }
    
}

// MARK: UICollectionViewDelegate

extension QPhotosViewController.PreviewController {
    
    @objc
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        if scrollView.isTracking == true {
            self._updateScroll()
        }
    }
    
    @objc
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer< CGPoint >) {
        super.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        
        if scrollView.isTracking == true {
            self._updateScroll()
        }
    }
    
    @objc
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        super.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        
        if decelerate == false {
            self._updateScroll()
        }
    }
    
    @objc
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        super.scrollViewDidEndDecelerating(scrollView)
        
        self._updateScroll()
    }
    
}
