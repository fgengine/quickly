//
//  Quickly
//

#if os(iOS)

    open class QSeparatorCollectionItem : QBackgroundColorCollectionItem {

        public var edgeInsets: UIEdgeInsets
        public var axis: UILayoutConstraintAxis
        public var color: UIColor

        public init(axis: UILayoutConstraintAxis, color: UIColor) {
            self.edgeInsets = UIEdgeInsets.zero
            self.axis = axis
            self.color = color
            super.init()
        }

    }

#endif
