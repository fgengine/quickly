//
//  Quickly
//

#if os(iOS)

    open class QSeparatorTableRow: QBackgroundColorTableRow {

        public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero

        public var color: UIColor

        public init(color: UIColor) {
            self.color = color
            super.init()
        }


    }

#endif
