//
//  Quickly
//

#if os(iOS)

    open class QTableController: NSObject, IQTableController, IQTableCellDelegate, IQTableDecorDelegate {

        public weak var tableView: UITableView? = nil {
            didSet { self.configure() }
        }
        public var rowHeight: CGFloat {
            didSet { if let tableView: UITableView = self.tableView { tableView.rowHeight = self.rowHeight } }
        }
        public var sectionHeaderHeight: CGFloat {
            didSet { if let tableView: UITableView = self.tableView { tableView.sectionHeaderHeight = self.sectionHeaderHeight } }
        }
        public var sectionFooterHeight: CGFloat {
            didSet { if let tableView: UITableView = self.tableView { tableView.sectionFooterHeight = self.sectionFooterHeight } }
        }
        public var estimatedRowHeight: CGFloat {
            didSet { if let tableView: UITableView = self.tableView { tableView.estimatedRowHeight = self.estimatedRowHeight } }
        }
        public var estimatedSectionHeaderHeight: CGFloat {
            didSet { if let tableView: UITableView = self.tableView { tableView.estimatedSectionHeaderHeight = self.estimatedSectionHeaderHeight } }
        }
        public var estimatedSectionFooterHeight: CGFloat {
            didSet { if let tableView: UITableView = self.tableView { tableView.estimatedSectionFooterHeight = self.estimatedSectionFooterHeight } }
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
                    let tableView: UITableView = self.tableView,
                    let selectedIndexPaths: [IndexPath] = tableView.indexPathsForSelectedRows
                    else { return [] }
                return selectedIndexPaths.flatMap({ (indexPath: IndexPath) -> IQTableRow? in
                    return self.sections[indexPath.section].rows[indexPath.row]
                })
            }
        }
        public var canEdit: Bool = true
        public var canMove: Bool = true
        public private(set) var isUpdating: Bool = false
        private var decors: [IQTableDecor.Type]
        private var cells: [IQTableCell.Type]

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
            self.cells = cells
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
            self.cells = cells
            super.init()
        }

        fileprivate func decorClass(data: IQTableData) -> IQTableDecor.Type? {
            return self.decors.first(where: { (decor: IQTableDecor.Type) -> Bool in
                return decor.using(any: data)
            })
        }

        fileprivate func cellClass(row: IQTableRow) -> IQTableCell.Type? {
            return self.cells.first(where: { (cell: IQTableCell.Type) -> Bool in
                return cell.using(any: row)
            })
        }

        open func configure() {
            if let tableView: UITableView = self.tableView {
                for type: IQTableDecor.Type in self.decors {
                    type.register(tableView: tableView)
                }
                for type: IQTableCell.Type in self.cells {
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

        public func section(index: Int) -> IQTableSection {
            return self.sections[index]
        }

        public func index(section: IQTableSection) -> Int? {
            return section.index
        }

        public func header(index: Int) -> IQTableData? {
            return self.sections[index].header
        }

        public func index(header: IQTableData) -> Int? {
            guard let section: IQTableSection = header.section else {
                return nil
            }
            return section.index
        }

        public func footer(index: Int) -> IQTableData? {
            return self.sections[index].footer
        }

        public func index(footer: IQTableData) -> Int? {
            guard let section: IQTableSection = footer.section else {
                return nil
            }
            return section.index
        }

        public func row(indexPath: IndexPath) -> IQTableRow {
            return self.sections[indexPath.section].rows[indexPath.row]
        }

        public func row(predicate: (IQTableRow) -> Bool) -> IQTableRow? {
            for section: IQTableSection in self.sections {
                for row: IQTableRow in section.rows {
                    if predicate(row) {
                        return row
                    }
                }
            }
            return nil
        }

        public func indexPath(row: IQTableRow) -> IndexPath? {
            return row.indexPath
        }

        public func indexPath(predicate: (IQTableRow) -> Bool) -> IndexPath? {
            for existSection: IQTableSection in self.sections {
                for existRow: IQTableRow in existSection.rows {
                    if predicate(existRow) {
                        return existRow.indexPath
                    }
                }
            }
            return nil
        }

        public func header(data: IQTableData) -> IQTableDecor? {
            guard
                let tableView: UITableView = self.tableView,
                let index: Int = self.index(header: data)
                else { return nil }
            return tableView.headerView(forSection: index) as? IQTableDecor
        }

        public func footer(data: IQTableData) -> IQTableDecor? {
            guard
                let tableView: UITableView = self.tableView,
                let index: Int = self.index(footer: data)
                else { return nil }
            return tableView.footerView(forSection: index) as? IQTableDecor
        }

        public func cell(row: IQTableRow) -> IQTableCell? {
            guard
                let tableView: UITableView = self.tableView,
                let indexPath: IndexPath = self.indexPath(row: row)
                else { return nil }
            return tableView.cellForRow(at: indexPath) as? IQTableCell
        }

        public func dequeue(data: IQTableData) -> IQTableDecor? {
            guard
                let tableView: UITableView = self.tableView,
                let decorClass: IQTableDecor.Type = self.decorClass(data: data),
                let decorView: IQTableDecor = decorClass.dequeue(tableView: tableView) as? IQTableDecor
                else { return nil }
            decorView.tableDelegate = self
            return decorView
        }

        public func dequeue(row: IQTableRow, indexPath: IndexPath) -> IQTableCell? {
            guard
                let tableView: UITableView = self.tableView,
                let cellClass: IQTableCell.Type = self.cellClass(row: row),
                let tableCell: IQTableCell = cellClass.dequeue(tableView: tableView, indexPath: indexPath) as? IQTableCell
                else { return nil }
            tableCell.tableDelegate = self;
            return tableCell
        }

        public func reload() {
            guard let tableView: UITableView = self.tableView else { return }
            tableView.reloadData()
        }

        public func beginUpdates() {
            if self.isUpdating == false {
                guard let tableView: UITableView = self.tableView else { return }
                self.isUpdating = true
                tableView.beginUpdates()
            }
        }

        public func insertSection(_ sections: [IQTableSection], index: Int, with animation: UITableViewRowAnimation) {
            self.sections.insert(contentsOf: sections, at: index)
            self.rebindSections(from: index, to: self.sections.endIndex)
            var indexSet: IndexSet = IndexSet()
            for section: IQTableSection in self.sections {
                if let sectionIndex: Int = section.index {
                    indexSet.insert(sectionIndex)
                }
            }
            if indexSet.count > 0 {
                if let tableView: UITableView = self.tableView {
                    tableView.insertSections(indexSet, with: animation)
                }
            }
        }

        public func deleteSection(_ sections: [IQTableSection], with animation: UITableViewRowAnimation) {
            var indexSet: IndexSet = IndexSet()
            for section: IQTableSection in self.sections {
                if let index: Int = self.sections.index(where: { (existSection: IQTableSection) -> Bool in
                    return (existSection === section)
                }) {
                    indexSet.insert(index)
                }
            }
            if indexSet.count > 0 {
                for index: Int in indexSet.reversed() {
                    let section: IQTableSection = self.sections[index]
                    self.sections.remove(at: index)
                    section.unbind()
                }
                self.rebindSections(from: indexSet.first!, to: self.sections.endIndex)
                if let tableView: UITableView = self.tableView {
                    tableView.deleteSections(indexSet, with: animation)
                }
            }
        }

        public func reloadSection(_ sections: [IQTableSection], with animation: UITableViewRowAnimation) {
            var indexSet: IndexSet = IndexSet()
            for section: IQTableSection in self.sections {
                if let index: Int = self.sections.index(where: { (existSection: IQTableSection) -> Bool in
                    return (existSection === section)
                }) {
                    indexSet.insert(index)
                }
            }
            if indexSet.count > 0 {
                if let tableView: UITableView = self.tableView {
                    tableView.reloadSections(indexSet, with: animation)
                }
            }
        }

        public func endUpdates() {
            if self.isUpdating == true {
                guard let tableView: UITableView = self.tableView else { return }
                tableView.endUpdates()
                self.isUpdating = false
            }
        }

        public func scroll(row: IQTableRow, scroll: UITableViewScrollPosition, animated: Bool) {
            guard
                let tableView: UITableView = self.tableView,
                let indexPath: IndexPath = self.indexPath(row: row)
                else { return }
            tableView.scrollToRow(at: indexPath, at: scroll, animated: animated)
        }

        public func isSelected(row: IQTableRow) -> Bool {
            guard
                let tableView: UITableView = self.tableView,
                let indexPath: IndexPath = self.indexPath(row: row),
                let selectedIndexPaths: [IndexPath] = tableView.indexPathsForSelectedRows
                else { return false }
            return selectedIndexPaths.contains(indexPath)
        }

        public func select(row: IQTableRow, scroll: UITableViewScrollPosition, animated: Bool) {
            guard
                let tableView: UITableView = self.tableView,
                let indexPath: IndexPath = self.indexPath(row: row)
                else { return }
            tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scroll)
        }

        public func deselect(row: IQTableRow, animated: Bool) {
            guard
                let tableView: UITableView = self.tableView,
                let indexPath: IndexPath = self.indexPath(row: row)
                else { return }
            tableView.deselectRow(at: indexPath, animated: animated)
        }

        public func update(header: IQTableData) {
            guard
                let tableView: UITableView = self.tableView,
                let index: Int = self.index(header: header),
                let decorView: IQTableDecor = tableView.headerView(forSection: index) as? IQTableDecor
                else { return }
            decorView.update(any: header)
        }

        public func update(footer: IQTableData) {
            guard
                let tableView: UITableView = self.tableView,
                let index: Int = self.index(footer: footer),
                let decorView: IQTableDecor = tableView.headerView(forSection: index) as? IQTableDecor
                else { return }
            decorView.update(any: footer)
        }

        public func update(row: IQTableRow) {
            guard
                let tableView: UITableView = self.tableView,
                let indexPath: IndexPath = self.indexPath(row: row),
                let cell: IQTableCell = tableView.cellForRow(at: indexPath) as? IQTableCell
                else { return }
            cell.update(any: row)
        }

    }

    extension QTableController {

        private func bindSections() {
            var sectionIndex: Int = 0
            for section: IQTableSection in self.sections {
                section.bind(self, sectionIndex)
                sectionIndex += 1
            }
        }

        private func rebindSections(from: Int, to: Int) {
            for index: Int in from..<to {
                self.sections[index].rebind(index)
            }
        }

        private func unbindSections() {
            for section: IQTableSection in self.sections {
                section.unbind()
            }
        }

    }

    extension QTableController: UITableViewDataSource {

        public func numberOfSections(
            in tableView: UITableView
        ) -> Int {
            return self.sections.count
        }

        public func tableView(
            _ tableView: UITableView,
            numberOfRowsInSection index: Int
        ) -> Int {
            let section: IQTableSection = self.section(index: index)
            if section.hidden == true {
                return 0
            }
            return section.rows.count
        }

        public func tableView(
            _ tableView: UITableView,
            cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
            let row: IQTableRow = self.row(indexPath: indexPath)
            return self.dequeue(row: row, indexPath: indexPath) as! UITableViewCell
        }

        public func tableView(
            _ tableView: UITableView,
            canEditRowAt indexPath: IndexPath
        ) -> Bool {
            let section: IQTableSection = self.section(index: indexPath.section)
            if section.canEdit == false {
                return false;
            }
            let row: IQTableRow = section.rows[indexPath.row]
            return row.canEdit;
        }

        public func tableView(
            _ tableView: UITableView,
            canMoveRowAt indexPath: IndexPath
        ) -> Bool {
            let section: IQTableSection = self.section(index: indexPath.section)
            if section.canMove == false {
                return false;
            }
            let row: IQTableRow = section.rows[indexPath.row]
            return row.canMove;
        }

    }

    extension QTableController: UITableViewDelegate {

        public func tableView(
            _ tableView: UITableView,
            willDisplay cell: UITableViewCell,
            forRowAt indexPath: IndexPath
        ) {
            if let tableCell: IQTableCell = cell as? IQTableCell {
                let row: IQTableRow = self.row(indexPath: indexPath)
                tableCell.set(any: row)
            }
        }

        public func tableView(
            _ tableView: UITableView,
            willDisplayHeaderView view: UIView,
            forSection section: Int
        ) {
            if let data: IQTableData = self.header(index: section) {
                if let decorView: IQTableDecor = view as? IQTableDecor {
                    decorView.set(any: data)
                }
            }
        }

        public func tableView(
            _ tableView: UITableView,
            willDisplayFooterView view: UIView,
            forSection section: Int
        ) {
            if let data: IQTableData = self.footer(index: section) {
                if let decorView: IQTableDecor = view as? IQTableDecor {
                    decorView.set(any: data)
                }
            }
        }

        public func tableView(
            _ tableView: UITableView,
            heightForRowAt indexPath: IndexPath
        ) -> CGFloat {
            let row: IQTableRow = self.row(indexPath: indexPath)
            if let cellClass = self.cellClass(row: row) {
                return cellClass.height(any: row, width: tableView.frame.size.width)
            }
            return 0
        }

        public func tableView(
            _ tableView: UITableView,
            heightForHeaderInSection section: Int
        ) -> CGFloat {
            if let data: IQTableData = self.header(index: section) {
                if let decorClass: IQTableDecor.Type = self.decorClass(data: data) {
                    return decorClass.height(any: data, width: tableView.frame.size.width)
                }
            }
            return 0
        }

        public func tableView(
            _ tableView: UITableView,
            heightForFooterInSection section: Int
        ) -> CGFloat {
            if let data: IQTableData = self.footer(index: section) {
                if let decorClass: IQTableDecor.Type = self.decorClass(data: data) {
                    return decorClass.height(any: data, width: tableView.frame.size.width)
                }
            }
            return 0
        }

        public func tableView(
            _ tableView: UITableView,
            viewForHeaderInSection section: Int
        ) -> UIView? {
            if let data: IQTableData = self.header(index: section) {
                if let decorClass: IQTableDecor.Type = self.decorClass(data: data) {
                    return decorClass.dequeue(tableView: tableView)
                }
            }
            return nil
        }

        public func tableView(
            _ tableView: UITableView,
            viewForFooterInSection section: Int
        ) -> UIView? {
            if let data: IQTableData = self.footer(index: section) {
                if let decorClass: IQTableDecor.Type = self.decorClass(data: data) {
                    return decorClass.dequeue(tableView: tableView)
                }
            }
            return nil
        }

        public func tableView(
            _ tableView: UITableView,
            shouldHighlightRowAt indexPath: IndexPath
        ) -> Bool {
            let row: IQTableRow = self.row(indexPath: indexPath)
            return row.canSelect
        }

        public func tableView(
            _ tableView: UITableView,
            willSelectRowAt indexPath: IndexPath
        ) -> IndexPath? {
            let row: IQTableRow = self.row(indexPath: indexPath)
            if row.canSelect == false {
                return nil
            }
            return indexPath
        }

        public func tableView(
            _ tableView: UITableView,
            willDeselectRowAt indexPath: IndexPath
        ) -> IndexPath? {
            let row: IQTableRow = self.row(indexPath: indexPath)
            if row.canSelect == false {
                return nil
            }
            return indexPath
        }

        public func tableView(
            _ tableView: UITableView,
            editingStyleForRowAt indexPath: IndexPath
        ) -> UITableViewCellEditingStyle {
            let row: IQTableRow = self.row(indexPath: indexPath)
            return row.editingStyle
        }

    }

#endif
