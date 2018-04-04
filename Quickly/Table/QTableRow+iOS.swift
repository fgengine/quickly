//
//  Quickly
//

#if os(iOS)

    open class QTableRow : IQTableRow {

        public private(set) weak var section: IQTableSection?
        public private(set) var indexPath: IndexPath?
        public var canSelect: Bool = true
        public var canEdit: Bool = false
        public var canMove: Bool = false
        public var selectionStyle: UITableViewCellSelectionStyle = .default
        public var editingStyle: UITableViewCellEditingStyle = .none

        public init() {
        }

        public func bind(_ section: IQTableSection, _ indexPath: IndexPath) {
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
