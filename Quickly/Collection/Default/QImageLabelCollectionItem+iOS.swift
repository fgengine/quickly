//
//  Quickly
//

#if os(iOS)

    open class QImageLabelCollectionItem : QBackgroundColorCollectionItem {

        public var edgeInsets: UIEdgeInsets

        public var image: QImageViewStyleSheet
        public var imageSize: CGSize
        public var imageSpacing: CGFloat

        public var label: QLabelStyleSheet

        public init(image: QImageViewStyleSheet, label: QLabelStyleSheet) {
            self.edgeInsets = UIEdgeInsets.zero
            self.image = image
            self.imageSize = CGSize(width: 96, height: 96)
            self.imageSpacing = 0
            self.label = label

            super.init()
        }

    }

#endif
