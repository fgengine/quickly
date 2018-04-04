//
//  Quickly
//

#if os(iOS)

    open class QLabelCollectionItem : QBackgroundColorCollectionItem {

        public var edgeInsets: UIEdgeInsets

        public var label: QLabelStyleSheet

        public init(label: QLabelStyleSheet) {
            self.edgeInsets = UIEdgeInsets.zero
            self.label = label

            super.init()
        }

    }

#endif
