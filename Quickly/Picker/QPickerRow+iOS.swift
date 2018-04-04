//
//  Quickly
//

#if os(iOS)

    open class QPickerRow : IQPickerRow {

        public private(set) weak var section: IQPickerSection?
        public private(set) var indexPath: IndexPath?

        public init() {
        }

        public func bind(_ section: IQPickerSection, _ indexPath: IndexPath) {
            self.section = section
            self.indexPath = indexPath
        }

        public func rebind(_ indexPath: IndexPath) {
            self.indexPath = indexPath
        }

        public func unbind() {
            self.indexPath = nil
            self.section = nil
        }

    }

#endif
