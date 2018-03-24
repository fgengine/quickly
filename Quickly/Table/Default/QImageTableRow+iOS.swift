//
//  Quickly
//

#if os(iOS)

    open class QImageTableRow: QBackgroundColorTableRow {

        public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero

        public var imageSource: QImageSource?
        public var imageCornerRadius: CGFloat = 0
        public var imageRoundCorners: Bool = false

    }

#endif
