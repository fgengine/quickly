//
//  Quickly
//

#if os(iOS)

    open class QTableSection: IQTableSection {

        public weak var controller: IQTableController? = nil
        public private(set) var index: Int? = nil
        public var canEdit: Bool = true
        public var canMove: Bool = true
        public var hidden: Bool = false

        public var header: IQTableData? = nil {
            willSet { self.unbindHeader() }
            didSet { self.bindHeader() }
        }
        public var footer: IQTableData? = nil {
            willSet { self.unbindFooter() }
            didSet { self.bindFooter() }
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
            self.bindHeader()
            self.bindFooter()
            self.bindRows()
        }

        public func rebind(_ index: Int) {
            self.index = index
            self.rebindRows(
                from: self.rows.startIndex,
                to: self.rows.endIndex
            )
        }

        public func unbind() {
            self.unbindHeader()
            self.unbindFooter()
            for row: IQTableRow in self.rows {
                row.unbind()
            }
            self.index = nil
            self.controller = nil
        }

        public func beginUpdates() {
            guard let controller: IQTableController = self.controller else { return }
            controller.beginUpdates()
        }

        public func insertRow(_ rows: [IQTableRow], index: Int, with animation: UITableViewRowAnimation) {
            self.rows.insert(contentsOf: rows, at: index)
            self.rebindRows(from: index, to: self.rows.endIndex)
            let indexPaths: [IndexPath] = rows.flatMap({ (row: IQTableRow) -> IndexPath? in
                return row.indexPath
            })
            if indexPaths.count > 0 {
                if let controller: IQTableController = self.controller, let tableView: UITableView = controller.tableView {
                    tableView.insertRows(at: indexPaths, with: animation)
                }
            }
        }

        public func deleteRow(_ rows: [IQTableRow], with animation: UITableViewRowAnimation) {
            var indices: [Int] = []
            for row: IQTableRow in rows {
                if let index: Int = self.rows.index(where: { (existRow: IQTableRow) -> Bool in
                    return (existRow === row)
                }) {
                    indices.append(index)
                }
            }
            if indices.count > 0 {
                let indexPaths: [IndexPath] = rows.flatMap({ (row: IQTableRow) -> IndexPath? in
                    return row.indexPath
                })
                for index: Int in indices.reversed() {
                    let row: IQTableRow = self.rows[index]
                    self.rows.remove(at: index)
                    row.unbind()
                }
                self.rebindRows(from: indices.first!, to: self.rows.endIndex)
                if indexPaths.count > 0 {
                    if let controller: IQTableController = self.controller, let tableView: UITableView = controller.tableView {
                        tableView.deleteRows(at: indexPaths, with: animation)
                    }
                }
            }
        }

        public func reloadRow(_ rows: [IQTableRow], with animation: UITableViewRowAnimation) {
            let indexPaths: [IndexPath] = rows.flatMap({ (row: IQTableRow) -> IndexPath? in
                return row.indexPath
            })
            if indexPaths.count > 0 {
                if let controller: IQTableController = self.controller, let tableView: UITableView = controller.tableView {
                    tableView.reloadRows(at: indexPaths, with: animation)
                }
            }
        }

        public func endUpdates() {
            guard let controller: IQTableController = self.controller else { return }
            controller.endUpdates()
        }

        public func moveRow(_ fromIndex: Int, toIndex: Int) {
            let row = self.rows[fromIndex]
            self.rows.remove(at: fromIndex)
            self.rows.insert(row, at: toIndex)
            self.rebindRows(
                from: min(fromIndex, toIndex),
                to: max(fromIndex, toIndex)
            )
        }

    }

    extension QTableSection {

        private func bindHeader() {
            if let header: IQTableData = self.header {
                header.bind(self)
            }
        }

        private func unbindHeader() {
            if let header: IQTableData = self.header {
                header.unbind()
            }
        }

        private func bindFooter() {
            if let footer: IQTableData = self.header {
                footer.bind(self)
            }
        }

        private func unbindFooter() {
            if let footer: IQTableData = self.header {
                footer.unbind()
            }
        }

        private func bindRows() {
            guard let sectionIndex: Int = self.index else { return }
            var rowIndex: Int = 0
            for row: IQTableRow in self.rows {
                row.bind(self, IndexPath(row: rowIndex, section: sectionIndex))
                rowIndex += 1
            }
        }

        private func rebindRows(from: Int, to: Int) {
            guard let sectionIndex: Int = self.index else { return }
            for rowIndex: Int in from..<to {
                self.rows[rowIndex].rebind(IndexPath(row: rowIndex, section: sectionIndex))
            }
        }

        private func unbindRows() {
            for row: IQTableRow in self.rows {
                row.unbind()
            }
        }

    }

#endif
