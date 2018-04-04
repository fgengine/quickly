//
//  Quickly
//

#if os(iOS)

    open class QImageTableRow : QBackgroundColorTableRow {

        public var edgeInsets: UIEdgeInsets

        public var image: QImageViewStyleSheet

        public init(image: QImageViewStyleSheet) {
            self.edgeInsets = UIEdgeInsets.zero
            self.image = image

            super.init()
        }

    }

#endif
