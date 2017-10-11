//
//  Quickly
//

#if os(iOS)

    open class QLabelCollectionItem: QBackgroundColorCollectionItem {

        public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero

        public var text: IQText?
        public var contentAlignment: QLabel.ContentAlignment = .left
        public var padding: CGFloat = 0
        public var numberOfLines: Int = 0
        public var lineBreakMode: NSLineBreakMode = .byWordWrapping

    }

#endif
