//
//  Quickly
//

#if os(iOS)

    open class QTableData: IQTableData {

        public private(set) weak var section: IQTableSection? = nil

        public init() {
        }

        public func bind(_ section: IQTableSection) {
            self.section = section
        }

        public func unbind() {
            self.section = nil
        }

    }

#endif
