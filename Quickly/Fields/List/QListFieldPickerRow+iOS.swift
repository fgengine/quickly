//
//  Quickly
//

#if os(iOS)

    open class QListFieldPickerRow : QPickerRow {

        public var fieldText: IQText
        public var fieldContentAlignment: QLabel.ContentAlignment
        public var fieldPadding: CGFloat
        public var fieldNumberOfLines: Int
        public var fieldLineBreakMode: NSLineBreakMode

        public var rowEdgeInsets: UIEdgeInsets

        public var rowText: IQText
        public var rowContentAlignment: QLabel.ContentAlignment
        public var rowPadding: CGFloat
        public var rowNumberOfLines: Int
        public var rowLineBreakMode: NSLineBreakMode

        public init(fieldText: IQText, rowText: IQText) {
            self.fieldText = fieldText
            self.fieldContentAlignment = .left
            self.fieldPadding = 0
            self.fieldNumberOfLines = 0
            self.fieldLineBreakMode = .byWordWrapping

            self.rowEdgeInsets = UIEdgeInsets.zero
            
            self.rowText = rowText
            self.rowContentAlignment = .center
            self.rowPadding = 0
            self.rowNumberOfLines = 1
            self.rowLineBreakMode = .byTruncatingMiddle

            super.init()
        }

        public convenience init(text: IQText) {
            self.init(fieldText: text, rowText: text)
        }

    }

#endif
