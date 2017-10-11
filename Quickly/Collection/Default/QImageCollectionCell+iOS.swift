//
//  Quickly
//

#if os(iOS)

    open class QImageCollectionCell< ItemType: QImageCollectionItem >: QBackgroundColorCollectionCell< ItemType > {

        internal var pictureView: QImageView!
        internal var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }

        open override class func size(
            item: ItemType,
            layout: UICollectionViewLayout,
            section: IQCollectionSection,
            size: CGSize
        ) -> CGSize {
            guard let source: QImageSource = item.source else {
                return CGSize.zero
            }
            let availableWidth: CGFloat = size.width - (item.edgeInsets.left + item.edgeInsets.right)
            let imageSize: CGSize = source.size(available: CGSize(
                width: availableWidth, height: availableWidth
            ))
            return CGSize(
                width: size.width,
                height: item.edgeInsets.top + imageSize.height + item.edgeInsets.bottom
            )
        }

        open override func setup() {
            super.setup()

            self.pictureView = QImageView(frame: self.contentView.bounds)
            self.pictureView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.pictureView)
        }

        open override func set(item: ItemType) {
            super.set(item: item)
            self.apply(item: item)
        }

        open override func update(item: ItemType) {
            super.update(item: item)
            self.apply(item: item)
        }

        private func apply(item: QImageCollectionItem) {
            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.pictureView.topLayout == self.contentView.topLayout + item.edgeInsets.top)
            selfConstraints.append(self.pictureView.leadingLayout == self.contentView.leadingLayout + item.edgeInsets.left)
            selfConstraints.append(self.pictureView.trailingLayout == self.contentView.trailingLayout - item.edgeInsets.right)
            selfConstraints.append(self.pictureView.bottomLayout == self.contentView.bottomLayout - item.edgeInsets.bottom)
            self.selfConstraints = selfConstraints

            self.pictureView.roundCorners = item.roundCorners
            self.pictureView.source = item.source
        }

    }

#endif
