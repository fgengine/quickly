//
//  Quickly
//

open class QImageCollectionCell< ItemType: QImageCollectionItem >: QBackgroundColorCollectionCell< ItemType > {

    private var _image: QImageView!

    private var currentEdgeInsets: UIEdgeInsets?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(
        item: ItemType,
        layout: UICollectionViewLayout,
        section: IQCollectionSection,
        size: CGSize
    ) -> CGSize {
        let availableWidth = size.width - (item.edgeInsets.left + item.edgeInsets.right)
        let imageSize = item.image.source.size(CGSize(width: availableWidth, height: availableWidth))
        return CGSize(
            width: size.width,
            height: item.edgeInsets.top + imageSize.height + item.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self._image = self.prepareImage()
        self._image.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self._image)
    }

    open func prepareImage() -> QImageView {
        return QImageView(frame: self.contentView.bounds)
    }

    open override func set(item: ItemType, animated: Bool) {
        super.set(item: item, animated: animated)
        
        if self.currentEdgeInsets != item.edgeInsets {
            self.currentEdgeInsets = item.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self._image.topLayout == self.contentView.topLayout + item.edgeInsets.top)
            selfConstraints.append(self._image.leadingLayout == self.contentView.leadingLayout + item.edgeInsets.left)
            selfConstraints.append(self._image.trailingLayout == self.contentView.trailingLayout - item.edgeInsets.right)
            selfConstraints.append(self._image.bottomLayout == self.contentView.bottomLayout - item.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        item.image.apply(target: self._image)
    }

}
