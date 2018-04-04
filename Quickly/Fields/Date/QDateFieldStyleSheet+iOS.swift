//
//  Quickly
//

#if os(iOS)

    public struct QDateFieldStyleSheet : IQStyleSheet {

        public var formatter: IQDateFieldFormatter?
        public var mode: QDateFieldMode
        public var calendar: Calendar?
        public var locale: Locale?
        public var minimumDate: Date?
        public var maximumDate: Date?
        public var placeholder: IQText?
        public var isEnabled: Bool

        public init() {
            self.mode = .date
            self.isEnabled = true
        }

        public func apply(target: QDateField) {
            target.formatter = self.formatter
            target.mode = self.mode
            target.calendar = self.calendar
            target.locale = self.locale
            target.minimumDate = self.minimumDate
            target.maximumDate = self.maximumDate
            target.placeholder = self.placeholder
            target.isEnabled = self.isEnabled
        }

    }

#endif
