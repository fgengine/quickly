//
//  Quickly
//

#if os(iOS)

    public struct QListFieldStyleSheet : IQStyleSheet {

        public var rows: [QListFieldPickerRow]
        public var rowHeight: CGFloat
        public var placeholder: IQText?
        public var isEnabled: Bool

        public init(rows: [QListFieldPickerRow]) {
            self.rows = rows
            self.rowHeight = 40
            self.isEnabled = true
        }

        public func apply(target: QListField) {
            target.rows = self.rows
            target.rowHeight = self.rowHeight
            target.placeholder = self.placeholder
            target.isEnabled = self.isEnabled
        }

    }

#endif
