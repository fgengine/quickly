//
//  Quickly
//

#if os(iOS)

    open class QSpaceCollectionItem: QBackgroundColorCollectionItem {

        public var size: CGSize

        public init(size: CGSize) {
            self.size = size
            super.init()
        }

    }

#endif
