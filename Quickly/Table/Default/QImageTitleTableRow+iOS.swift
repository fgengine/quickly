//
//  Quickly
//

#if os(iOS)

    open class QImageTitleTableRow: QBackgroundColorTableRow {

        public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero

        public var imageSource: QImageSource?
        public var imageWidth: CGFloat = 96
        public var imageCornerRadius: CGFloat = 0
        public var imageRoundCorners: Bool = false
        public var imageSpacing: CGFloat = 0

        public var titleText: IQText?
        public var titleContentAlignment: QLabel.ContentAlignment = .left
        public var titlePadding: CGFloat = 0
        public var titleNumberOfLines: Int = 0
        public var titleLineBreakMode: NSLineBreakMode = .byWordWrapping

    }

#endif
