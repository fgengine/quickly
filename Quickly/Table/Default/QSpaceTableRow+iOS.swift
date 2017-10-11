//
//  Quickly
//

#if os(iOS)

    open class QSpaceTableRow: QBackgroundColorTableRow {

        public var size: CGFloat

        public init(size: CGFloat) {
            self.size = size
            super.init()
        }

    }

#endif
