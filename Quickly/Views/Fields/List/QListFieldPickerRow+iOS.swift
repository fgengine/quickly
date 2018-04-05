//
//  Quickly
//

#if os(iOS)

    open class QListFieldPickerRow : QPickerRow {

        public var field: QLabelStyleSheet

        public var rowEdgeInsets: UIEdgeInsets
        public var row: QLabelStyleSheet

        public init(field: QLabelStyleSheet, row: QLabelStyleSheet) {
            self.field = field
            self.rowEdgeInsets = UIEdgeInsets.zero
            self.row = row

            super.init()
        }

        public convenience init(field: IQText, row: IQText) {
            self.init(
                field: QLabelStyleSheet(text: field),
                row: QLabelStyleSheet(
                    text: row,
                    verticalAlignment: .center,
                    horizontalAlignment: .center,
                    lineBreakMode: .byWordWrapping
                )
            )
        }

        public convenience init(text: IQText) {
            self.init(
                field: QLabelStyleSheet(text: text),
                row: QLabelStyleSheet(
                    text: text,
                    verticalAlignment: .center,
                    horizontalAlignment: .center,
                    lineBreakMode: .byWordWrapping
                )
            )
        }

    }

#endif
