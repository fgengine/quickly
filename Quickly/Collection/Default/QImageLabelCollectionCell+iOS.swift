//
//  Quickly
//

#if os(iOS)

    open class QImageLabelCollectionCell< ItemType: QImageLabelCollectionItem >: QBackgroundColorCollectionCell< ItemType > {

        private var _image: QImageView!
        private var _label: QLabel!

        private var currentEdgeInsets: UIEdgeInsets?
        private var currentImageSize: CGSize?
        private var currentImageSpacing: CGFloat?

        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }
        private var imageConstraints: [NSLayoutConstraint] = [] {
            willSet { self._image.removeConstraints(self.imageConstraints) }
            didSet { self._image.addConstraints(self.imageConstraints) }
        }

        open override class func size(
            item: ItemType,
            layout: UICollectionViewLayout,
            section: IQCollectionSection,
            size: CGSize
        ) -> CGSize {
            let availableWidth = size.width - (item.edgeInsets.left + item.edgeInsets.right)
            let labelSize = item.label.text.size(width: availableWidth)
            return CGSize(
                width: item.edgeInsets.left + max(item.imageSize.width, labelSize.width) + item.edgeInsets.right,
                height: item.edgeInsets.top + item.imageSize.height + item.imageSpacing + labelSize.height + item.edgeInsets.bottom
            )
        }

        open override func setup() {
            super.setup()

            self._image = self.prepareImage()
            self._image.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self._image)

            self._label = self.prepareLabel()
            self._label.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self._label)
        }

        open func prepareImage() -> QImageView {
            return QImageView(frame: self.contentView.bounds)
        }

        open func prepareLabel() -> QLabel {
            return QLabel(frame: self.contentView.bounds)
        }

        open override func set(item: ItemType) {
            super.set(item: item)
            self.apply(item: item)
        }

        open override func update(item: ItemType) {
            super.update(item: item)
            self.apply(item: item)
        }

        private func apply(item: QImageLabelCollectionItem) {
            if self.currentEdgeInsets != item.edgeInsets || self.currentImageSpacing != item.imageSpacing {
                self.currentEdgeInsets = item.edgeInsets
                self.currentImageSpacing = item.imageSpacing

                var selfConstraints: [NSLayoutConstraint] = []
                selfConstraints.append(self._image.topLayout == self.contentView.topLayout + item.edgeInsets.top)
                selfConstraints.append(self._image.leadingLayout == self.contentView.leadingLayout + item.edgeInsets.left)
                selfConstraints.append(self._image.trailingLayout == self.contentView.trailingLayout - item.edgeInsets.right)
                selfConstraints.append(self._image.bottomLayout == self._label.topLayout - item.edgeInsets.bottom)
                selfConstraints.append(self._label.leadingLayout == self.contentView.leadingLayout + item.edgeInsets.left)
                selfConstraints.append(self._label.trailingLayout == self.contentView.trailingLayout - item.edgeInsets.right)
                selfConstraints.append(self._label.bottomLayout == self.contentView.bottomLayout - item.edgeInsets.bottom)
                self.selfConstraints = selfConstraints
            }
            if self.currentImageSize != item.imageSize {
                self.currentImageSize = item.imageSize

                var imageConstraints: [NSLayoutConstraint] = []
                imageConstraints.append(self._image.widthLayout == item.imageSize.width)
                imageConstraints.append(self._image.heightLayout == item.imageSize.height)
                self.imageConstraints = imageConstraints
            }
            item.image.apply(target: self._image)
            item.label.apply(target: self._label)
        }

    }

#endif
