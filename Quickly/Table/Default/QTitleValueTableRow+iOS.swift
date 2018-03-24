//
//  Quickly
//

#if os(iOS)

    open class QTitleValueTableRow: QBackgroundColorTableRow {

        public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero

        public var titleText: IQText?
        public var titleContentAlignment: QLabel.ContentAlignment = .left
        public var titlePadding: CGFloat = 0
        public var titleNumberOfLines: Int = 0
        public var titleLineBreakMode: NSLineBreakMode = .byWordWrapping
        public var titleSpacing: CGFloat = 0

        public var valueText: IQText?
        public var valueContentAlignment: QLabel.ContentAlignment = .left
        public var valuePadding: CGFloat = 0
        public var valueNumberOfLines: Int = 0
        public var valueLineBreakMode: NSLineBreakMode = .byWordWrapping

    }

#endif
