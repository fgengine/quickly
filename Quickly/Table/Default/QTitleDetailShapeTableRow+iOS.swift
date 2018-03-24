//
//  Quickly
//

#if os(iOS)

    open class QTitleDetailShapeTableRow: QBackgroundColorTableRow {

        public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero

        public var titleText: IQText?
        public var titleContentAlignment: QLabel.ContentAlignment = .left
        public var titlePadding: CGFloat = 0
        public var titleNumberOfLines: Int = 0
        public var titleLineBreakMode: NSLineBreakMode = .byWordWrapping
        public var titleSpacing: CGFloat = 0

        public var detailText: IQText?
        public var detailContentAlignment: QLabel.ContentAlignment = .left
        public var detailPadding: CGFloat = 0
        public var detailNumberOfLines: Int = 0
        public var detailLineBreakMode: NSLineBreakMode = .byWordWrapping
        public var detailSpacing: CGFloat = 0

        public var shapeModel: IQShapeModel?
        public var shapeWidth: CGFloat = 16

    }

#endif
