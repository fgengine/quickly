//
//  Quickly
//

open class QTableController : NSObject, IQTableController, IQTableCellDelegate, IQTableDecorDelegate {

    public typealias DecorType = IQTableController.DecorType
    public typealias CellType = IQTableController.CellType

    public weak var tableView: UITableView? {
        didSet { self.configure() }
    }
    public var rowHeight: CGFloat {
        didSet { if let tableView = self.tableView { tableView.rowHeight = self.rowHeight } }
    }
    public var sectionHeaderHeight: CGFloat {
        didSet { if let tableView = self.tableView { tableView.sectionHeaderHeight = self.sectionHeaderHeight } }
    }
    public var sectionFooterHeight: CGFloat {
        didSet { if let tableView = self.tableView { tableView.sectionFooterHeight = self.sectionFooterHeight } }
    }
    public var estimatedRowHeight: CGFloat {
        didSet { if let tableView = self.tableView { tableView.estimatedRowHeight = self.estimatedRowHeight } }
    }
    public var estimatedSectionHeaderHeight: CGFloat {
        didSet { if let tableView = self.tableView { tableView.estimatedSectionHeaderHeight = self.estimatedSectionHeaderHeight } }
    }
    public var estimatedSectionFooterHeight: CGFloat {
        didSet { if let tableView = self.tableView { tableView.estimatedSectionFooterHeight = self.estimatedSectionFooterHeight } }
    }
    public var sections: [IQTableSection] = [] {
        willSet { self.unbindSections() }
        didSet { self.bindSections() }
    }
    public var rows: [IQTableRow] {
        get {
            return self.sections.flatMap({ (section: IQTableSection) -> [IQTableRow] in
                return section.rows
            })
        }
    }
    public var selectedRows: [IQTableRow] {
        get {
            guard
                let tableView = self.tableView,
                let selectedIndexPaths = tableView.indexPathsForSelectedRows
                else { return [] }
            return selectedIndexPaths.compactMap({ (indexPath: IndexPath) -> IQTableRow? in
                return self.sections[indexPath.section].rows[indexPath.row]
            })
        }
    }
    public var canEdit: Bool = true
    public var canMove: Bool = true
    public private(set) var isBatchUpdating: Bool = false
    private var decors: [IQTableDecor.Type]
    private var aliasDecors: [QMetatype : IQTableDecor.Type]
    private var cells: [IQTableCell.Type]
    private var aliasCells: [QMetatype : IQTableCell.Type]
    private var observer: QObserver< IQTableControllerObserver >

    public init(
        cells: [IQTableCell.Type]
    ) {
        self.rowHeight = UITableViewAutomaticDimension
        self.sectionHeaderHeight = UITableViewAutomaticDimension
        self.sectionFooterHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = UITableViewAutomaticDimension
        self.estimatedSectionHeaderHeight = UITableViewAutomaticDimension
        self.estimatedSectionFooterHeight = UITableViewAutomaticDimension

        self.decors = []
        self.aliasDecors = [:]
        self.cells = cells
        self.aliasCells = [:]
        self.observer = QObserver< IQTableControllerObserver >()
        super.init()
    }

    public init(
        decors: [IQTableDecor.Type],
        cells: [IQTableCell.Type]
    ) {
        self.rowHeight = UITableViewAutomaticDimension
        self.sectionHeaderHeight = UITableViewAutomaticDimension
        self.sectionFooterHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = UITableViewAutomaticDimension
        self.estimatedSectionHeaderHeight = UITableViewAutomaticDimension
        self.estimatedSectionFooterHeight = UITableViewAutomaticDimension

        self.decors = decors
        self.aliasDecors = [:]
        self.cells = cells
        self.aliasCells = [:]
        self.observer = QObserver< IQTableControllerObserver >()
        super.init()
    }

    fileprivate func decorClass(data: IQTableData) -> IQTableDecor.Type? {
        let dataMetatype = QMetatype(data)
        if let metatype = self.aliasDecors.first(where: { return $0.key == dataMetatype }) {
            return metatype.value
        }
        let usings = self.decors.filter({ return $0.using(any: data) })
        guard usings.count > 0 else { return nil }
        if usings.count > 1 {
            let typeOfData = type(of: data)
            let levels = usings.compactMap({ (type) -> (IQTableDecor.Type, UInt)? in
                guard let level = type.usingLevel(any: typeOfData) else { return nil }
                return (type, level)
            })
            let sorted = levels.sorted(by: { return $0.1 > $1.1 })
            let decorType = sorted.first!.0
            self.aliasDecors[dataMetatype] = decorType
            return decorType
        } else {
            let decorType = usings.first!
            self.aliasDecors[dataMetatype] = decorType
            return decorType
        }
    }

    fileprivate func cellClass(row: IQTableRow) -> IQTableCell.Type? {
        let rowMetatype = QMetatype(row)
        if let metatype = self.aliasCells.first(where: { return $0.key == rowMetatype }) {
            return metatype.value
        }
        let usings = self.cells.filter({ return $0.using(any: row) })
        guard usings.count > 0 else { return nil }
        if usings.count > 1 {
            let typeOfData = type(of: row)
            let levels = usings.compactMap({ (type) -> (IQTableCell.Type, UInt)? in
                guard let level = type.usingLevel(any: typeOfData) else { return nil }
                return (type, level)
            })
            let sorted = levels.sorted(by: { return $0.1 > $1.1 })
            let cellType = sorted.first!.0
            self.aliasCells[rowMetatype] = cellType
            return cellType
        } else {
            let cellType = usings.first!
            self.aliasCells[rowMetatype] = cellType
            return cellType
        }
    }

    open func configure() {
        if let tableView = self.tableView {
            for type in self.decors {
                type.register(tableView: tableView)
            }
            for type in self.cells {
                type.register(tableView: tableView)
            }
            tableView.rowHeight = self.rowHeight
            tableView.sectionHeaderHeight = self.sectionHeaderHeight
            tableView.sectionFooterHeight = self.sectionFooterHeight
            tableView.estimatedRowHeight = self.estimatedRowHeight
            tableView.estimatedSectionHeaderHeight = self.estimatedSectionHeaderHeight
            tableView.estimatedSectionFooterHeight = self.estimatedSectionFooterHeight
        }
        self.reload()
    }

    open func addObserver(_ observer: IQTableControllerObserver) {
        self.observer.add(observer)
    }

    open func removeObserver(_ observer: IQTableControllerObserver) {
        self.observer.remove(observer)
    }

    open func section(index: Int) -> IQTableSection {
        return self.sections[index]
    }

    open func index(section: IQTableSection) -> Int? {
        return section.index
    }

    open func header(index: Int) -> IQTableData? {
        return self.sections[index].header
    }

    open func index(header: IQTableData) -> Int? {
        guard let section = header.section else { return nil }
        return section.index
    }

    open func footer(index: Int) -> IQTableData? {
        return self.sections[index].footer
    }

    open func index(footer: IQTableData) -> Int? {
        guard let section = footer.section else { return nil }
        return section.index
    }

    open func row(indexPath: IndexPath) -> IQTableRow {
        return self.sections[indexPath.section].rows[indexPath.row]
    }

    open func row(predicate: (IQTableRow) -> Bool) -> IQTableRow? {
        for section in self.sections {
            for row in section.rows {
                if predicate(row) {
                    return row
                }
            }
        }
        return nil
    }

    open func indexPath(row: IQTableRow) -> IndexPath? {
        return row.indexPath
    }

    open func indexPath(predicate: (IQTableRow) -> Bool) -> IndexPath? {
        for existSection in self.sections {
            for existRow in existSection.rows {
                if predicate(existRow) {
                    return existRow.indexPath
                }
            }
        }
        return nil
    }

    open func header(data: IQTableData) -> IQTableDecor? {
        guard
            let tableView = self.tableView,
            let index = self.index(header: data)
            else { return nil }
        return tableView.headerView(forSection: index) as? IQTableDecor
    }

    open func footer(data: IQTableData) -> IQTableDecor? {
        guard
            let tableView = self.tableView,
            let index = self.index(footer: data)
            else { return nil }
        return tableView.footerView(forSection: index) as? IQTableDecor
    }

    open func cell(row: IQTableRow) -> IQTableCell? {
        guard
            let tableView = self.tableView,
            let indexPath = self.indexPath(row: row)
            else { return nil }
        return tableView.cellForRow(at: indexPath) as? IQTableCell
    }

    open func dequeue(data: IQTableData) -> DecorType? {
        guard
            let tableView = self.tableView,
            let decorClass = self.decorClass(data: data),
            let decorView = decorClass.dequeue(tableView: tableView)
            else { return nil }
        decorView.tableDelegate = self
        return decorView
    }

    open func dequeue(row: IQTableRow, indexPath: IndexPath) -> CellType? {
        guard
            let tableView = self.tableView,
            let cellClass = self.cellClass(row: row),
            let tableCell = cellClass.dequeue(tableView: tableView, indexPath: indexPath)
            else { return nil }
        tableCell.tableDelegate = self;
        return tableCell
    }

    open func reload() {
        guard let tableView = self.tableView else { return }
        tableView.reloadData()
        self.notifyUpdate()
    }

    open func insertSection(_ sections: [IQTableSection], index: Int, with animation: UITableViewRowAnimation) {
        self.sections.insert(contentsOf: sections, at: index)
        self.rebindSections(from: index, to: self.sections.endIndex)
        var indexSet = IndexSet()
        for section in self.sections {
            if let sectionIndex = section.index {
                indexSet.insert(sectionIndex)
            }
        }
        if indexSet.count > 0 {
            if let tableView = self.tableView {
                tableView.insertSections(indexSet, with: animation)
            }
        }
        if self.isBatchUpdating == false {
            self.notifyUpdate()
        }
    }

    open func deleteSection(_ sections: [IQTableSection], with animation: UITableViewRowAnimation) {
        var indexSet = IndexSet()
        for section in self.sections {
            if let index = self.sections.index(where: { return ($0 === section) }) {
                indexSet.insert(index)
            }
        }
        if indexSet.count > 0 {
            for index in indexSet.reversed() {
                let section = self.sections[index]
                self.sections.remove(at: index)
                section.unbind()
            }
            self.rebindSections(from: indexSet.first!, to: self.sections.endIndex)
            if let tableView = self.tableView {
                tableView.deleteSections(indexSet, with: animation)
            }
        }
        if self.isBatchUpdating == false {
            self.notifyUpdate()
        }
    }

    open func reloadSection(_ sections: [IQTableSection], with animation: UITableViewRowAnimation) {
        var indexSet = IndexSet()
        for section in self.sections {
            if let index = self.sections.index(where: { return ($0 === section) }) {
                indexSet.insert(index)
            }
        }
        if indexSet.count > 0 {
            if let tableView = self.tableView {
                tableView.reloadSections(indexSet, with: animation)
            }
        }
        if self.isBatchUpdating == false {
            self.notifyUpdate()
        }
    }

    open func performBatchUpdates(_ updates: (() -> Void)) {
        #if DEBUG
            assert(self.isBatchUpdating == true, "Recurcive calling IQTableController.performBatchUpdates()")
        #endif
        self.isBatchUpdating = true
        if let tableView = self.tableView {
            tableView.beginUpdates()
        }
        updates()
        if let tableView = self.tableView {
            tableView.endUpdates()
        }
        self.isBatchUpdating = false
        self.notifyUpdate()
    }

    open func scroll(row: IQTableRow, scroll: UITableViewScrollPosition, animated: Bool) {
        guard
            let tableView = self.tableView,
            let indexPath = self.indexPath(row: row)
            else { return }
        tableView.scrollToRow(at: indexPath, at: scroll, animated: animated)
    }

    open func isSelected(row: IQTableRow) -> Bool {
        guard
            let tableView = self.tableView,
            let indexPath = self.indexPath(row: row),
            let selectedIndexPaths = tableView.indexPathsForSelectedRows
            else { return false }
        return selectedIndexPaths.contains(indexPath)
    }

    open func select(row: IQTableRow, scroll: UITableViewScrollPosition, animated: Bool) {
        guard
            let tableView = self.tableView,
            let indexPath = self.indexPath(row: row)
            else { return }
        tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scroll)
    }

    open func deselect(row: IQTableRow, animated: Bool) {
        guard
            let tableView = self.tableView,
            let indexPath = self.indexPath(row: row)
            else { return }
        tableView.deselectRow(at: indexPath, animated: animated)
    }

    open func update(header: IQTableData, animated: Bool) {
        guard
            let tableView = self.tableView,
            let index = self.index(header: header),
            let decorView = tableView.headerView(forSection: index) as? IQTableDecor
            else { return }
        decorView.set(any: header, animated: animated)
        if self.isBatchUpdating == false {
            self.notifyUpdate()
        }
    }

    open func update(footer: IQTableData, animated: Bool) {
        guard
            let tableView = self.tableView,
            let index = self.index(footer: footer),
            let decorView = tableView.headerView(forSection: index) as? IQTableDecor
            else { return }
        decorView.set(any: footer, animated: animated)
        if self.isBatchUpdating == false {
            self.notifyUpdate()
        }
    }

    open func update(row: IQTableRow, animated: Bool) {
        guard
            let tableView = self.tableView,
            let indexPath = self.indexPath(row: row),
            let cell = tableView.cellForRow(at: indexPath) as? IQTableCell
            else { return }
        cell.set(any: row, animated: animated)
        if self.isBatchUpdating == false {
            self.notifyUpdate()
        }
    }

}

extension QTableController {

    private func bindSections() {
        var sectionIndex: Int = 0
        for section in self.sections {
            section.bind(self, sectionIndex)
            sectionIndex += 1
        }
    }

    private func rebindSections(from: Int, to: Int) {
        for index in from..<to {
            self.sections[index].rebind(index)
        }
    }

    private func unbindSections() {
        for section in self.sections {
            section.unbind()
        }
    }

    private func notifyUpdate() {
        self.observer.notify({ $0.update(self) })
    }

}

extension QTableController : UIScrollViewDelegate {

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.observer.notify({ $0.scroll(self, tableView: self.tableView!) })
    }

}

extension QTableController : UITableViewDataSource {

    open func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return self.sections.count
    }

    open func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection index: Int
    ) -> Int {
        let section = self.section(index: index)
        if section.hidden == true {
            return 0
        }
        return section.rows.count
    }

    open func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let row = self.row(indexPath: indexPath)
        return self.dequeue(row: row, indexPath: indexPath).unsafelyUnwrapped
    }

    open func tableView(
        _ tableView: UITableView,
        canEditRowAt indexPath: IndexPath
    ) -> Bool {
        let section = self.section(index: indexPath.section)
        if section.canEdit == false {
            return false;
        }
        let row = section.rows[indexPath.row]
        return row.canEdit;
    }

    open func tableView(
        _ tableView: UITableView,
        canMoveRowAt indexPath: IndexPath
    ) -> Bool {
        let section = self.section(index: indexPath.section)
        if section.canMove == false {
            return false;
        }
        let row = section.rows[indexPath.row]
        return row.canMove;
    }

}

extension QTableController : UITableViewDelegate {

    open func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if let tableCell = cell as? IQTableCell {
            let row = self.row(indexPath: indexPath)
            tableCell.set(any: row, animated: false)
        }
    }

    open func tableView(
        _ tableView: UITableView,
        willDisplayHeaderView view: UIView,
        forSection section: Int
    ) {
        if let data = self.header(index: section) {
            if let decorView = view as? IQTableDecor {
                decorView.set(any: data, animated: false)
            }
        }
    }

    open func tableView(
        _ tableView: UITableView,
        willDisplayFooterView view: UIView,
        forSection section: Int
    ) {
        if let data = self.footer(index: section) {
            if let decorView = view as? IQTableDecor {
                decorView.set(any: data, animated: false)
            }
        }
    }

    open func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let row = self.row(indexPath: indexPath)
        if let cellClass = self.cellClass(row: row) {
            return cellClass.height(any: row, width: tableView.frame.size.width)
        }
        return 0
    }

    open func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        if let data = self.header(index: section) {
            if let decorClass = self.decorClass(data: data) {
                return decorClass.height(any: data, width: tableView.frame.size.width)
            }
        }
        return 0
    }

    open func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        if let data = self.footer(index: section) {
            if let decorClass = self.decorClass(data: data) {
                return decorClass.height(any: data, width: tableView.frame.size.width)
            }
        }
        return 0
    }

    open func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        if let data = self.header(index: section) {
            if let decorClass = self.decorClass(data: data) {
                return decorClass.dequeue(tableView: tableView)
            }
        }
        return nil
    }

    open func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        if let data = self.footer(index: section) {
            if let decorClass = self.decorClass(data: data) {
                return decorClass.dequeue(tableView: tableView)
            }
        }
        return nil
    }

    open func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath
    ) -> Bool {
        let row = self.row(indexPath: indexPath)
        return row.canSelect
    }

    open func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        let row = self.row(indexPath: indexPath)
        if row.canSelect == false {
            return nil
        }
        return indexPath
    }

    open func tableView(
        _ tableView: UITableView,
        willDeselectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        let row = self.row(indexPath: indexPath)
        if row.canSelect == false {
            return nil
        }
        return indexPath
    }

    open func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCellEditingStyle {
        let row = self.row(indexPath: indexPath)
        return row.editingStyle
    }

}
