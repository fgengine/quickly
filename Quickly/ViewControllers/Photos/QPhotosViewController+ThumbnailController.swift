//
//  Quickly
//

import UIKit

extension QPhotosViewController {
    
    class ThumbnailController : QCollectionController {
        
        public var itemStyle: ThumbnailItemStyle
        
        var didSelectPhoto: (_ photo: IQPhotoItem) -> Void
        
        private var _items: [PhotoItem]
        private var _photos: [IQPhotoItem]
        private var _selectedPhoto: IQPhotoItem?
        
        init(
            itemStyle: ThumbnailItemStyle,
            photos: [IQPhotoItem],
            selectedPhoto: IQPhotoItem?,
            didSelectPhoto: @escaping (_ photo: IQPhotoItem) -> Void
        ) {
            self.didSelectPhoto = didSelectPhoto
            self.itemStyle = itemStyle
            self._photos = photos
            self._selectedPhoto = selectedPhoto
            self._items = []
            super.init(cells: [
                PhotoCell.self
            ])
        }
        
        override func rebuild() {
            self._items = self._photos.compactMap({
                return PhotoItem(
                    photo: $0,
                    selectedAlpha: self.itemStyle.selectedAlpha,
                    selectedBorderWidth: self.itemStyle.selectedBorderWidth,
                    selectedBorderColor: self.itemStyle.selectedBorderColor,
                    unselectedAlpha: self.itemStyle.unselectedAlpha,
                    unselectedBorderWidth: self.itemStyle.unselectedBorderWidth,
                    unselectedBorderColor: self.itemStyle.unselectedBorderColor
                )
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
                    self.select(item: item, scroll: .centeredHorizontally, animated: true)
                }
            }
        }
        
        func set(selectedPhoto: IQPhotoItem?) {
            self._selectedPhoto = selectedPhoto
            if let selectedPhoto = selectedPhoto {
                if let item = self._items.first(where: { return $0.photo === selectedPhoto }) {
                    self.select(item: item, scroll: .centeredHorizontally, animated: true)
                } else {
                    self.deselectAll(animated: true)
                }
            } else {
                self.deselectAll(animated: true)
            }
        }
        
    }
    
}

// MARK: UICollectionViewDelegate

extension QPhotosViewController.ThumbnailController {
    
    @objc
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.item(indexPath: indexPath)
        if let item = item as? PhotoItem {
            self._selectedPhoto = item.photo
            self.didSelectPhoto(item.photo)
        }
    }
    
}
