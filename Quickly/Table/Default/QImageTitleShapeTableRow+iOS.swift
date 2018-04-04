//
//  Quickly
//

#if os(iOS)

    open class QImageTitleShapeTableRow : QBackgroundColorTableRow {

        public var edgeInsets: UIEdgeInsets

        public var image: QImageViewStyleSheet
        public var imageWidth: CGFloat
        public var imageSpacing: CGFloat

        public var title: QLabelStyleSheet

        public var shape: IQShapeModel
        public var shapeWidth: CGFloat
        public var shapeSpacing: CGFloat

        public init(image: QImageViewStyleSheet, title: QLabelStyleSheet, shape: IQShapeModel) {
            self.edgeInsets = UIEdgeInsets.zero
            self.image = image
            self.imageWidth = 96
            self.imageSpacing = 0
            self.title = title
            self.shape = shape
            self.shapeWidth = 16
            self.shapeSpacing = 0

            super.init()
        }

    }

#endif
