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
    
    @available(iOS 11.0, *)
    public var leadingSwipeConfiguration: UISwipeActionsConfiguration? {
        set(value) { self._leadingSwipeConfiguration = value }
        get { return self._leadingSwipeConfiguration as? UISwipeActionsConfiguration }
    }
    
    @available(iOS 11.0, *)
    public var trailingSwipeConfiguration: UISwipeActionsConfiguration? {
        set(value) { self._trailingSwipeConfiguration = value }
        get { return self._trailingSwipeConfiguration as? UISwipeActionsConfiguration }
    }
    
    public var cacheHeight: CGFloat?
    
    private var _leadingSwipeConfiguration: Any?
    
    private var _trailingSwipeConfiguration: Any?

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

    @available(iOS 11.0, *)
    public init(
        canSelect: Bool = true,
        canEdit: Bool = false,
        canMove: Bool = false,
        selectionStyle: UITableViewCell.SelectionStyle = .default,
        editingStyle: UITableViewCell.EditingStyle = .none,
        leadingSwipeConfiguration: UISwipeActionsConfiguration? = nil,
        trailingSwipeConfiguration: UISwipeActionsConfiguration? = nil
    ) {
        self.canSelect = canSelect
        self.canEdit = canEdit
        self.canMove = canMove
        self.selectionStyle = selectionStyle
        self.editingStyle = editingStyle
        self._leadingSwipeConfiguration = leadingSwipeConfiguration
        self._trailingSwipeConfiguration = trailingSwipeConfiguration
    }
    
    public func bind(_ section: IQTableSection, _ indexPath: IndexPath) {
        self.section = section
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
