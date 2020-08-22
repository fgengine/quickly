//
//  Quickly
//

public struct QTableControllerReloadOption : OptionSet {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let resetCache = QTableControllerReloadOption(rawValue: 1 << 0)
    
}

public protocol IQTableControllerObserver : class {

    func beginScroll(_ controller: IQTableController, tableView: UITableView)
    func scroll(_ controller: IQTableController, tableView: UITableView)
    func finishScroll(_ controller: IQTableController, tableView: UITableView, velocity: CGPoint) -> CGPoint?
    func endScroll(_ controller: IQTableController, tableView: UITableView)

    func update(_ controller: IQTableController)

}

public protocol IQTableController : UITableViewDataSource, UITableViewDelegate {
    
    typealias TableView = UITableView & IQContainerSpec
    typealias Decor = IQTableDecor.Dequeue
    typealias Cell = IQTableCell.DequeueType

    var tableView: TableView? { set get }
    var estimatedRowHeight: CGFloat { set get }
    var estimatedSectionHeaderHeight: CGFloat { set get }
    var estimatedSectionFooterHeight: CGFloat { set get }

    var sections: [IQTableSection] { set get }
    var rows: [IQTableRow] { get }
    var selectedRows: [IQTableRow] { get }
    var canEdit: Bool { get }
    var canMove: Bool { get }
    var isBatchUpdating: Bool { get }

    func setup()
    
    func configure()
    
    func rebuild()

    func add(observer: IQTableControllerObserver, priority: UInt)
    func remove(observer: IQTableControllerObserver)

    func section(index: Int) -> IQTableSection
    func index(section: IQTableSection) -> Int?

    func header(index: Int) -> IQTableData?
    func index(header: IQTableData) -> Int?

    func footer(index: Int) -> IQTableData?
    func index(footer: IQTableData) -> Int?

    func row(indexPath: IndexPath) -> IQTableRow
    func row(predicate: (IQTableRow) -> Bool) -> IQTableRow?

    func indexPath(row: IQTableRow) -> IndexPath?
    func indexPath(predicate: (IQTableRow) -> Bool) -> IndexPath?

    func header(data: IQTableData) -> IQTableDecor?
    func footer(data: IQTableData) -> IQTableDecor?
    func cell(row: IQTableRow) -> IQTableCell?

    func dequeue(data: IQTableData) -> Decor?
    func dequeue(row: IQTableRow, indexPath: IndexPath) -> Cell?

    func reload(_ options: QTableControllerReloadOption)

    func prependSection(_ section: IQTableSection, with animation: UITableView.RowAnimation?)
    func prependSection(_ sections: [IQTableSection], with animation: UITableView.RowAnimation?)
    func appendSection(_ section: IQTableSection, with animation: UITableView.RowAnimation?)
    func appendSection(_ sections: [IQTableSection], with animation: UITableView.RowAnimation?)
    func insertSection(_ section: IQTableSection, index: Int, with animation: UITableView.RowAnimation?)
    func insertSection(_ sections: [IQTableSection], index: Int, with animation: UITableView.RowAnimation?)
    func deleteSection(_ section: IQTableSection, with animation: UITableView.RowAnimation?)
    func deleteSection(_ sections: [IQTableSection], with animation: UITableView.RowAnimation?)
    func reloadSection(_ section: IQTableSection, with animation: UITableView.RowAnimation?)
    func reloadSection(_ sections: [IQTableSection], with animation: UITableView.RowAnimation?)

    func performBatchUpdates(_ updates: (() -> Void))

    func scroll(row: IQTableRow, scroll: UITableView.ScrollPosition, animated: Bool)

    func isSelected(row: IQTableRow) -> Bool
    func select(row: IQTableRow, scroll: UITableView.ScrollPosition, animated: Bool)
    func deselect(row: IQTableRow, animated: Bool)

    func update(header: IQTableData, animated: Bool)
    func update(footer: IQTableData, animated: Bool)
    func update(row: IQTableRow, animated: Bool)

}

public extension IQTableController {

    func prependSection(_ section: IQTableSection, with animation: UITableView.RowAnimation? = nil) {
        self.insertSection([ section ], index: self.sections.startIndex, with: animation)
    }

    func prependSection(_ sections: [IQTableSection], with animation: UITableView.RowAnimation? = nil) {
        self.insertSection(sections, index: self.sections.startIndex, with: animation)
    }

    func appendSection(_ section: IQTableSection, with animation: UITableView.RowAnimation? = nil) {
        self.insertSection([ section ], index: self.sections.endIndex, with: animation)
    }

    func appendSection(_ sections: [IQTableSection], with animation: UITableView.RowAnimation? = nil) {
        self.insertSection(sections, index: self.sections.endIndex, with: animation)
    }

    func insertSection(_ section: IQTableSection, index: Int, with animation: UITableView.RowAnimation? = nil) {
        self.insertSection([ section ], index: index, with: animation)
    }

    func deleteSection(_ section: IQTableSection, with animation: UITableView.RowAnimation? = nil) {
        self.deleteSection([ section ], with: animation)
    }

    func reloadSection(_ section: IQTableSection, with animation: UITableView.RowAnimation? = nil) {
        self.reloadSection([ section ], with: animation)
    }
    
}
