//
//  Quickly
//

#if os(iOS)

    open class QTitleDetailShapeTableRow : QBackgroundColorTableRow {

        public var edgeInsets: UIEdgeInsets

        public var title: QLabelStyleSheet
        public var titleSpacing: CGFloat

        public var detail: QLabelStyleSheet

        public var shape: IQShapeModel
        public var shapeWidth: CGFloat
        public var shapeSpacing: CGFloat

        public init(title: QLabelStyleSheet, detail: QLabelStyleSheet, shape: IQShapeModel) {
            self.edgeInsets = UIEdgeInsets.zero
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
