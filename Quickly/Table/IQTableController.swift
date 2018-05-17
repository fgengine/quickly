//
//  Quickly
//

public protocol IQTableControllerObserver : class {

    func scroll(_ controller: IQTableController, tableView: UITableView)
    func update(_ controller: IQTableController)

}

public protocol IQTableController : UITableViewDataSource, UITableViewDelegate {

    typealias DecorType = IQTableDecor.DequeueType
    typealias CellType = IQTableCell.DequeueType

    var tableView: UITableView? { set get }
    var rowHeight: CGFloat { set get }
    var sectionHeaderHeight: CGFloat { set get }
    var sectionFooterHeight: CGFloat { set get }
    var estimatedRowHeight: CGFloat { set get }
    var estimatedSectionHeaderHeight: CGFloat { set get }
    var estimatedSectionFooterHeight: CGFloat { set get }

    var sections: [IQTableSection] { set get }
    var rows: [IQTableRow] { get }
    var selectedRows: [IQTableRow] { get }
    var canEdit: Bool { get }
    var canMove: Bool { get }
    var isBatchUpdating: Bool { get }

    func configure()

    func addObserver(_ observer: IQTableControllerObserver, priority: UInt)
    func removeObserver(_ observer: IQTableControllerObserver)

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

    func dequeue(data: IQTableData) -> DecorType?
    func dequeue(row: IQTableRow, indexPath: IndexPath) -> CellType?

    func reload()

    func prependSection(_ section: IQTableSection, with animation: UITableViewRowAnimation)
    func prependSection(_ sections: [IQTableSection], with animation: UITableViewRowAnimation)
    func appendSection(_ section: IQTableSection, with animation: UITableViewRowAnimation)
    func appendSection(_ sections: [IQTableSection], with animation: UITableViewRowAnimation)
    func insertSection(_ section: IQTableSection, index: Int, with animation: UITableViewRowAnimation)
    func insertSection(_ sections: [IQTableSection], index: Int, with animation: UITableViewRowAnimation)
    func deleteSection(_ section: IQTableSection, with animation: UITableViewRowAnimation)
    func deleteSection(_ sections: [IQTableSection], with animation: UITableViewRowAnimation)
    func reloadSection(_ section: IQTableSection, with animation: UITableViewRowAnimation)
    func reloadSection(_ sections: [IQTableSection], with animation: UITableViewRowAnimation)

    func performBatchUpdates(_ updates: (() -> Void))

    func scroll(row: IQTableRow, scroll: UITableViewScrollPosition, animated: Bool)

    func isSelected(row: IQTableRow) -> Bool
    func select(row: IQTableRow, scroll: UITableViewScrollPosition, animated: Bool)
    func deselect(row: IQTableRow, animated: Bool)

    func update(header: IQTableData, animated: Bool)
    func update(footer: IQTableData, animated: Bool)
    func update(row: IQTableRow, animated: Bool)

}

public extension IQTableController {

    public func prependSection(_ section: IQTableSection, with animation: UITableViewRowAnimation) {
        self.insertSection([ section ], index: self.sections.startIndex, with: animation)
    }

    public func prependSection(_ sections: [IQTableSection], with animation: UITableViewRowAnimation) {
        self.insertSection(sections, index: self.sections.startIndex, with: animation)
    }

    public func appendSection(_ section: IQTableSection, with animation: UITableViewRowAnimation) {
        self.insertSection([ section ], index: self.sections.endIndex, with: animation)
    }

    public func appendSection(_ sections: [IQTableSection], with animation: UITableViewRowAnimation) {
        self.insertSection(sections, index: self.sections.endIndex, with: animation)
    }

    public func insertSection(_ section: IQTableSection, index: Int, with animation: UITableViewRowAnimation) {
        self.insertSection([ section ], index: index, with: animation)
    }

    public func deleteSection(_ section: IQTableSection, with animation: UITableViewRowAnimation) {
        self.deleteSection([ section ], with: animation)
    }

    public func reloadSection(_ section: IQTableSection, with animation: UITableViewRowAnimation) {
        self.reloadSection([ section ], with: animation)
    }

}