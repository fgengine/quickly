//
//  Quickly
//

#if os(iOS)

    open class QLabelTableRow: QBackgroundColorTableRow {

        public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero

        public var labelText: IQText?
        public var labelContentAlignment: QLabel.ContentAlignment = .left
        public var labelPadding: CGFloat = 0
        public var labelNumberOfLines: Int = 0
        public var labelLineBreakMode: NSLineBreakMode = .byWordWrapping

    }

#endif
