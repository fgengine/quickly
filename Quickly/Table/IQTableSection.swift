//
//  Quickly
//

public protocol IQTableSection : class {

    var controller: IQTableController? { get }
    var index: Int? { get }
    var canEdit: Bool { get }
    var canMove: Bool { get }
    var hidden: Bool { get }

    var header: IQTableData? { set get }
    var footer: IQTableData? { set get }
    var rows: [IQTableRow] { get }

    func bind(_ controller: IQTableController, _ index: Int)
    func rebind(_ index: Int)
    func unbind()

    func prependRow(_ row: IQTableRow, with animation: UITableViewRowAnimation?)
    func prependRow(_ rows: [IQTableRow], with animation: UITableViewRowAnimation?)
    func appendRow(_ row: IQTableRow, with animation: UITableViewRowAnimation?)
    func appendRow(_ rows: [IQTableRow], with animation: UITableViewRowAnimation?)
    func insertRow(_ row: IQTableRow, index: Int, with animation: UITableViewRowAnimation?)
    func insertRow(_ rows: [IQTableRow], index: Int, with animation: UITableViewRowAnimation?)
    func deleteRow(_ row: IQTableRow, with animation: UITableViewRowAnimation?)
    func deleteRow(_ rows: [IQTableRow], with animation: UITableViewRowAnimation?)
    func reloadRow(_ row: IQTableRow, with animation: UITableViewRowAnimation?)
    func reloadRow(_ rows: [IQTableRow], with animation: UITableViewRowAnimation?)

    func moveRow(_ fromRow: IQTableRow, toIndex: Int) -> Bool
    func moveRow(_ fromIndex: Int, toIndex: Int)

}

public extension IQTableSection {

    public func prependRow(_ row: IQTableRow, with animation: UITableViewRowAnimation? = nil) {
        self.insertRow([ row ], index: self.rows.startIndex, with: animation)
    }

    public func prependRow(_ rows: [IQTableRow], with animation: UITableViewRowAnimation? = nil) {
        self.insertRow(rows, index: self.rows.startIndex, with: animation)
    }

    public func appendRow(_ row: IQTableRow, with animation: UITableViewRowAnimation? = nil) {
        self.insertRow([ row ], index: self.rows.endIndex, with: animation)
    }

    public func appendRow(_ rows: [IQTableRow], with animation: UITableViewRowAnimation? = nil) {
        self.insertRow(rows, index: self.rows.endIndex, with: animation)
    }

    public func insertRow(_ row: IQTableRow, index: Int, with animation: UITableViewRowAnimation? = nil) {
        self.insertRow([ row ], index: index, with: animation)
    }

    public func deleteRow(_ row: IQTableRow, with animation: UITableViewRowAnimation? = nil) {
        self.deleteRow([ row ], with: animation)
    }

    public func reloadRow(_ row: IQTableRow, with animation: UITableViewRowAnimation? = nil) {
        self.reloadRow([ row ], with: animation)
    }

    public func moveRow(_ fromRow: IQTableRow, toIndex: Int) -> Bool {
        guard let fromIndex = self.rows.index(where: { return ($0 === fromRow) }) else { return false }
        self.moveRow(fromIndex, toIndex: toIndex)
        return true
    }

}
