//
//  Quickly
//

#if os(iOS)

    open class QLabelPickerRow : QPickerRow {

        public var edgeInsets: UIEdgeInsets

        public var labelText: IQText
        public var labelContentAlignment: QLabel.ContentAlignment
        public var labelPadding: CGFloat
        public var labelNumberOfLines: Int
        public var labelLineBreakMode: NSLineBreakMode

        public init(text: IQText) {
            self.edgeInsets = UIEdgeInsets.zero

            self.labelText = text
            self.labelContentAlignment = .center
            self.labelPadding = 0
            self.labelNumberOfLines = 0
            self.labelLineBreakMode = .byWordWrapping

            super.init()
        }

    }

#endif
