//
//  Quickly
//

open class QTableSection : IQTableSection {

    public weak var controller: IQTableController?
    public private(set) var index: Int?
    public var canEdit: Bool = true {
        didSet { self._reloadSection() }
    }
    public var canMove: Bool = true {
        didSet { self._reloadSection() }
    }
    public var hidden: Bool = false {
        didSet { self._reloadSection() }
    }

    public var header: IQTableData? {
        willSet { self._unbindHeader() }
        didSet {
            self._bindHeader()
            self._reloadSection()
        }
    }
    public var footer: IQTableData? {
        willSet { self._unbindFooter() }
        didSet {
            self._bindFooter()
            self._reloadSection()
        }
    }
    public private(set) var rows: [IQTableRow]

    public init(rows: [IQTableRow]) {
        self.rows = rows
    }

    public init(header: IQTableData, rows: [IQTableRow]) {
        self.header = header
        self.rows = rows
    }

    public init(footer: IQTableData, rows: [IQTableRow]) {
        self.footer = footer
        self.rows = rows
    }

    public init(header: IQTableData, footer: IQTableData, rows: [IQTableRow]) {
        self.header = header
        self.footer = footer
        self.rows = rows
    }

    public func bind(_ controller: IQTableController, _ index: Int) {
        self.controller = controller
        self.index = index
        self._bindHeader()
        self._bindFooter()
        self._bindRows()
    }

    public func rebind(_ index: Int) {
        self.index = index
        self._rebindRows(
            from: self.rows.startIndex,
            to: self.rows.endIndex
        )
    }

    public func unbind() {
        self._unbindHeader()
        self._unbindFooter()
        for row in self.rows {
            row.unbind()
        }
        self.index = nil
        self.controller = nil
    }
    
    public func setRows(_ rows: [IQTableRow]) {
        self._unbindRows()
        self.rows = rows
        self._bindRows()
    }

    public func insertRow(_ rows: [IQTableRow], index: Int, with animation: UITableView.RowAnimation? = nil) {
        self.rows.insert(contentsOf: rows, at: index)
        self._rebindRows(from: index, to: self.rows.endIndex)
        let indexPaths = rows.compactMap({ return $0.indexPath })
        if indexPaths.count > 0 {
            if let controller = self.controller, let tableView = controller.tableView, let animation = animation {
                tableView.insertRows(at: indexPaths, with: animation)
            }
        }
    }

    public func deleteRow(_ rows: [IQTableRow], with animation: UITableView.RowAnimation? = nil) {
        var indices: [Int] = []
        for row in rows {
            if let index = self.rows.index(where: { return ($0 === row) }) {
                indices.append(index)
            }
        }
        if indices.count > 0 {
            indices.sort()
            let indexPaths = rows.compactMap({ return $0.indexPath })
            for index in indices.reversed() {
                let row = self.rows[index]
                self.rows.remove(at: index)
                row.unbind()
            }
            self._rebindRows(from: indices.first!, to: self.rows.endIndex)
            if indexPaths.count > 0 {
                if let controller = self.controller, let tableView = controller.tableView, let animation = animation {
                    tableView.deleteRows(at: indexPaths, with: animation)
                }
            }
        }
    }

    public func reloadRow(_ rows: [IQTableRow], with animation: UITableView.RowAnimation? = nil) {
        let indexPaths = rows.compactMap({ return $0.indexPath })
        if indexPaths.count > 0 {
            if let controller = self.controller, let tableView = controller.tableView, let animation = animation {
                tableView.reloadRows(at: indexPaths, with: animation)
            }
        }
    }

    public func moveRow(_ fromIndex: Int, toIndex: Int) {
        let row = self.rows[fromIndex]
        self.rows.remove(at: fromIndex)
        self.rows.insert(row, at: toIndex)
        self._rebindRows(
            from: min(fromIndex, toIndex),
            to: max(fromIndex, toIndex)
        )
    }
    
    public func resetCache() {
        self.rows.forEach({ $0.resetCacheHeight() })
    }

}

extension QTableSection {

    private func _bindHeader() {
        if let header = self.header {
            header.bind(self)
        }
    }

    private func _unbindHeader() {
        if let header = self.header {
            header.unbind()
        }
    }

    private func _bindFooter() {
        if let footer = self.header {
            footer.bind(self)
        }
    }

    private func _unbindFooter() {
        if let footer = self.header {
            footer.unbind()
        }
    }

    private func _bindRows() {
        guard let sectionIndex = self.index else { return }
        var rowIndex: Int = 0
        for row in self.rows {
            row.bind(self, IndexPath(row: rowIndex, section: sectionIndex))
            rowIndex += 1
        }
    }

    private func _rebindRows(from: Int, to: Int) {
        guard let sectionIndex = self.index else { return }
        for rowIndex in from..<to {
            self.rows[rowIndex].rebind(IndexPath(row: rowIndex, section: sectionIndex))
        }
    }

    private func _unbindRows() {
        for row in self.rows {
            row.unbind()
        }
    }

    private func _reloadSection() {
        guard
            let index = self.index,
            let controller = self.controller,
            let tableView = controller.tableView
            else { return }
        if controller.isBatchUpdating == false {
            tableView.reloadSections(IndexSet(integer: index), with: .none)
        }
    }

}
