//
//  Quickly
//

#if os(iOS)

    public protocol IQTableRow: class {

        var canSelect: Bool { get }
        var canEdit: Bool { get }
        var canMove: Bool { get }
        var selectionStyle: UITableViewCellSelectionStyle { get }
        var editingStyle: UITableViewCellEditingStyle { get }

    }

#endif
