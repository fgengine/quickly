//
//  Quickly
//

extension QPhotosViewController {
    
    class ThumbnailLayout : UICollectionViewFlowLayout {

        public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            guard
                let collectionView = self.collectionView,
                let superAttributes = super.layoutAttributesForElements(in: rect),
                let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
                else { return nil }
            let contentSize = self.collectionViewContentSize
            let boundsSize = collectionView.bounds.size
            if (contentSize.width < boundsSize.width) || (contentSize.height < boundsSize.height) {
                let offset = CGPoint(
                    x: (boundsSize.width - contentSize.width) / 2,
                    y: 0
                )
                attributes.forEach({ layoutAttribute in
                    layoutAttribute.frame = layoutAttribute.frame.offsetBy(dx: offset.x, dy: offset.y)
                })
            }
            return attributes
        }

    }
    
}
