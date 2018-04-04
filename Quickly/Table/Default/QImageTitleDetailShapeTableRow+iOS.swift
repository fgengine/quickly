//
//  Quickly
//

#if os(iOS)

    open class QImageTitleDetailShapeTableRow : QBackgroundColorTableRow {

        public var edgeInsets: UIEdgeInsets

        public var image: QImageViewStyleSheet
        public var imageWidth: CGFloat
        public var imageSpacing: CGFloat

        public var title: QLabelStyleSheet
        public var titleSpacing: CGFloat = 0

        public var detail: QLabelStyleSheet

        public var shape: IQShapeModel
        public var shapeWidth: CGFloat
        public var shapeSpacing: CGFloat

        public init(image: QImageViewStyleSheet, title: QLabelStyleSheet, detail: QLabelStyleSheet, shape: IQShapeModel) {
            self.edgeInsets = UIEdgeInsets.zero
            self.image = image
            self.imageWidth = 96
            self.imageSpacing = 0
            self.title = title
            self.titleSpacing = 0
            self.detail = detail
            self.shape = shape
            self.shapeWidth = 16
            self.shapeSpacing = 0

            super.init()
        }

    }

#endif
