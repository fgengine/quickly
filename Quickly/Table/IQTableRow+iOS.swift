//
//  Quickly
//

#if os(iOS)

    public protocol IQTableRow : class {

        var section: IQTableSection? { get }
        var indexPath: IndexPath? { get }
        var canSelect: Bool { get }
        var canEdit: Bool { get }
        var canMove: Bool { get }
        var selectionStyle: UITableViewCellSelectionStyle { get }
        var editingStyle: UITableViewCellEditingStyle { get }

        func bind(_ section: IQTableSection, _ indexPath: IndexPath)
        func rebind(_ indexPath: IndexPath)
        func unbind()

    }

#endif
