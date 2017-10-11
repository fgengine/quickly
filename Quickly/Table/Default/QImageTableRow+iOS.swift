//
//  Quickly
//

#if os(iOS)

    open class QImageTableRow: QBackgroundColorTableRow {

        public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero

        public var source: QImageSource?
        public var roundCorners: Bool = false

    }

#endif
