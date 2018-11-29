//
//  Quickly
//

open class QTableRow : IQTableRow {

    public private(set) weak var section: IQTableSection?
    public private(set) var indexPath: IndexPath?
    public var canSelect: Bool
    public var canEdit: Bool
    public var canMove: Bool
    public var selectionStyle: UITableViewCell.SelectionStyle
    public var editingStyle: UITableViewCell.EditingStyle
    public var cacheHeight: CGFloat?

    public init(
        canSelect: Bool = true,
        canEdit: Bool = false,
        canMove: Bool = false,
        selectionStyle: UITableViewCell.SelectionStyle = .default,
        editingStyle: UITableViewCell.EditingStyle = .none
    ) {
        self.canSelect = canSelect
        self.canEdit = canEdit
        self.canMove = canMove
        self.selectionStyle = selectionStyle
        self.editingStyle = editingStyle
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
    
    open func resetCacheHeight() {
        self.cacheHeight = nil
    }

}
