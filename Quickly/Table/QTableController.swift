//
//  Quickly
//

import UIKit

open class QTableController : NSObject, IQTableController, IQTableCellDelegate, IQTableDecorDelegate {
    
    public typealias TableView = IQTableController.TableView
    public typealias Decor = IQTableController.Decor
    public typealias Cell = IQTableController.Cell

    public weak var tableView: TableView? {
        didSet { if self.tableView != nil { self.configure() } }
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
        willSet { self._unbindSections() }
        didSet { self._bindSections() }
    }
    var indexPaths: [IndexPath] {
        return self.sections.flatMap({ return $0.indexPaths })
    }
    public var rows: [IQTableRow] {
        return self.sections.flatMap({ (section: IQTableSection) -> [IQTableRow] in
            return section.rows
        })
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
    public var postVisibleIndexPaths: [IndexPath] = []
    public var preVisibleIndexPaths: [IndexPath] = []
    public var visibleCells: [UITableViewCell] = []
    public private(set) var isBatchUpdating: Bool = false
    
    private var _decors: [IQTableDecor.Type]
    private var _aliasDecors: [QMetatype : IQTableDecor.Type]
    private var _cells: [IQTableCell.Type]
    private var _aliasCells: [QMetatype : IQTableCell.Type]
    private var _cacheHeight: [Int : [Int : CGFloat]]
    private var _observer: QObserver< IQTableControllerObserver >

    public init(
        cells: [IQTableCell.Type]
    ) {
        self.estimatedRowHeight = 44
        self.estimatedSectionHeaderHeight = 44
        self.estimatedSectionFooterHeight = 44

        self._decors = []
        self._aliasDecors = [:]
        self._cells = cells
        self._aliasCells = [:]
        self._cacheHeight = [:]
        self._observer = QObserver< IQTableControllerObserver >()
        super.init()
        self.setup()
    }

    public init(
        decors: [IQTableDecor.Type],
        cells: [IQTableCell.Type]
    ) {
        self.estimatedRowHeight = 44
        self.estimatedSectionHeaderHeight = 44
        self.estimatedSectionFooterHeight = 44

        self._decors = decors
        self._aliasDecors = [:]
        self._cells = cells
        self._aliasCells = [:]
        self._cacheHeight = [:]
        self._observer = QObserver< IQTableControllerObserver >()
        super.init()
        self.setup()
    }
    
    open func setup() {
    }

    open func configure() {
        if let tableView = self.tableView {
            for type in self._decors {
                type.register(tableView: tableView)
            }
            for type in self._cells {
                type.register(tableView: tableView)
            }
            tableView.estimatedRowHeight = self.estimatedRowHeight
            tableView.estimatedSectionHeaderHeight = self.estimatedSectionHeaderHeight
            tableView.estimatedSectionFooterHeight = self.estimatedSectionFooterHeight
        }
        self.rebuild()
    }
    
    open func rebuild() {
        self.reload([])
    }

    open func add(observer: IQTableControllerObserver, priority: UInt) {
        self._observer.add(observer, priority: priority)
    }

    open func remove(observer: IQTableControllerObserver) {
        self._observer.remove(observer)
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

    open func dequeue(data: IQTableData) -> Decor? {
        guard
            let tableView = self.tableView,
            let decorClass = self._decorClass(data: data),
            let decorView = decorClass.dequeue(tableView: tableView)
            else { return nil }
        decorView.tableDelegate = self
        return decorView
    }

    open func dequeue(row: IQTableRow, indexPath: IndexPath) -> Cell? {
        guard
            let tableView = self.tableView,
            let cellClass = self._cellClass(row: row),
            let tableCell = cellClass.dequeue(tableView: tableView, indexPath: indexPath)
            else { return nil }
        tableCell.tableDelegate = self;
        return tableCell
    }

    open func reload(_ options: QTableControllerReloadOption) {
        if options.contains(.resetCache) == true {
            self.sections.forEach({ $0.resetCache() })
        }
        if let tableView = self.tableView {
            tableView.reloadData()
            self._notifyUpdate()
        }
    }

    open func insertSection(_ sections: [IQTableSection], index: Int, with animation: UITableView.RowAnimation? = nil) {
        self.sections.insert(contentsOf: sections, at: index)
        self._bindSections(from: index, to: self.sections.endIndex)
        var indexSet = IndexSet()
        for section in self.sections {
            if let sectionIndex = section.index {
                indexSet.insert(sectionIndex)
            }
        }
        if indexSet.count > 0 {
            if let tableView = self.tableView, let animation = animation {
                tableView.insertSections(indexSet, with: animation)
            }
        }
        if self.isBatchUpdating == false {
            self._notifyUpdate()
        }
    }

    open func deleteSection(_ sections: [IQTableSection], with animation: UITableView.RowAnimation? = nil) {
        var indexSet = IndexSet()
        for section in sections {
            if let index = self.sections.firstIndex(where: { return ($0 === section) }) {
                indexSet.insert(index)
            }
        }
        if indexSet.count > 0 {
            for index in indexSet.reversed() {
                let section = self.sections[index]
                self.sections.remove(at: index)
                section.unbind()
            }
            self._bindSections(from: indexSet.first!, to: self.sections.endIndex)
            if let tableView = self.tableView, let animation = animation {
                tableView.deleteSections(indexSet, with: animation)
            }
        }
        if self.isBatchUpdating == false {
            self._notifyUpdate()
        }
    }

    open func reloadSection(_ sections: [IQTableSection], with animation: UITableView.RowAnimation? = nil) {
        var indexSet = IndexSet()
        for section in sections {
            if let index = self.sections.firstIndex(where: { return ($0 === section) }) {
                indexSet.insert(index)
            }
        }
        if indexSet.count > 0 {
            if let tableView = self.tableView, let animation = animation {
                tableView.reloadSections(indexSet, with: animation)
            }
        }
        if self.isBatchUpdating == false {
            self._notifyUpdate()
        }
    }

    open func performBatchUpdates(_ updates: (() -> Void)) {
        if self.isBatchUpdating == false {
            self.isBatchUpdating = true
            if let tableView = self.tableView {
                tableView.beginUpdates()
            }
            updates()
            if let tableView = self.tableView {
                tableView.endUpdates()
            }
            self.isBatchUpdating = false
            self._notifyUpdate()
        } else {
            updates()
        }
    }

    open func scroll(row: IQTableRow, scroll: UITableView.ScrollPosition, animated: Bool) {
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

    open func select(row: IQTableRow, scroll: UITableView.ScrollPosition, animated: Bool) {
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
        decorView.prepare(any: header, spec: tableView, animated: animated)
        if self.isBatchUpdating == false {
            self._notifyUpdate()
        }
    }

    open func update(footer: IQTableData, animated: Bool) {
        guard
            let tableView = self.tableView,
            let index = self.index(footer: footer),
            let decorView = tableView.headerView(forSection: index) as? IQTableDecor
            else { return }
        decorView.prepare(any: footer, spec: tableView, animated: animated)
        if self.isBatchUpdating == false {
            self._notifyUpdate()
        }
    }

    open func update(row: IQTableRow, animated: Bool) {
        guard
            let tableView = self.tableView,
            let indexPath = self.indexPath(row: row),
            let cell = tableView.cellForRow(at: indexPath) as? IQTableCell
            else { return }
        cell.prepare(any: row, spec: tableView, animated: animated)
        if self.isBatchUpdating == false {
            self._notifyUpdate()
        }
    }

}

// MARK: Private

private extension QTableController {
    
    func _bindSections() {
        var sectionIndex: Int = 0
        for section in self.sections {
            section.bind(self, sectionIndex)
            sectionIndex += 1
        }
    }
    
    func _bindSections(from: Int, to: Int) {
        for index in from..<to {
            self.sections[index].bind(self, index)
        }
    }
    
    func _unbindSections() {
        for section in self.sections {
            section.unbind()
        }
    }
    
    func _notifyUpdate() {
        self._observer.notify({ $0.update(self) })
    }
    
    func _decorClass(data: IQTableData) -> IQTableDecor.Type? {
        let dataMetatype = QMetatype(data)
        if let metatype = self._aliasDecors.first(where: { return $0.key == dataMetatype }) {
            return metatype.value
        }
        if let decorType = self._aliasDecors[dataMetatype] {
            return decorType
        }
        let usings = self._decors.filter({ return $0.using(any: data) })
        if usings.count > 1 {
            let typeOfData = type(of: data)
            let levels = usings.compactMap({ (type) -> (IQTableDecor.Type, UInt)? in
                guard let level = type.usingLevel(any: typeOfData) else { return nil }
                return (type, level)
            })
            let sorted = levels.sorted(by: { return $0.1 > $1.1 })
            if let sortedFirst = sorted.first {
                self._aliasDecors[dataMetatype] = sortedFirst.0
                return sortedFirst.0
            }
        } else if let usingFirst = usings.first {
            self._aliasDecors[dataMetatype] = usingFirst
            return usingFirst
        }
        return nil
    }
    
    func _cellClass(row: IQTableRow) -> IQTableCell.Type? {
        let rowMetatype = QMetatype(row)
        if let metatype = self._aliasCells.first(where: { return $0.key == rowMetatype }) {
            return metatype.value
        }
        if let cellType = self._aliasCells[rowMetatype] {
            return cellType
        }
        let usings = self._cells.filter({ return $0.using(any: row) })
        if usings.count > 1 {
            let typeOfData = type(of: row)
            let levels = usings.compactMap({ (type) -> (IQTableCell.Type, UInt)? in
                guard let level = type.usingLevel(any: typeOfData) else { return nil }
                return (type, level)
            })
            let sorted = levels.sorted(by: { return $0.1 > $1.1 })
            if let sortedFirst = sorted.first {
                self._aliasCells[rowMetatype] = sortedFirst.0
                return sortedFirst.0
            }
        } else if let usingFirst = usings.first {
            self._aliasCells[rowMetatype] = usingFirst
            return usingFirst
        }
        return nil
    }
    
    func _updateVisibleIndexPaths(_ tableView: UITableView) {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
            let indexPaths = self.indexPaths
            if let visibleIndexPath = visibleIndexPaths.first, let index = indexPaths.firstIndex(of: visibleIndexPath) {
                let start = 0
                let end = max(0, index - 1)
                self.postVisibleIndexPaths = Array(indexPaths[start..<end])
            } else {
                self.postVisibleIndexPaths = []
            }
            if let visibleIndexPath = visibleIndexPaths.last, let index = indexPaths.firstIndex(of: visibleIndexPath) {
                let start = min(index + 1, indexPaths.count)
                let end = indexPaths.count
                self.preVisibleIndexPaths = Array(indexPaths[start..<end])
            } else {
                self.preVisibleIndexPaths = []
            }
        } else {
            self.postVisibleIndexPaths = []
            self.preVisibleIndexPaths = []
        }
    }

}

// MARK: UIScrollViewDelegate

extension QTableController : UIScrollViewDelegate {
    
    @objc
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let tableView = self.tableView!
        self._observer.notify({ $0.beginScroll(self, tableView: tableView) })
    }

    @objc
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tableView = self.tableView!
        self._observer.notify({ $0.scroll(self, tableView: tableView) })
    }
    
    @objc
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            let tableView = self.tableView!
            self._observer.notify({ $0.endScroll(self, tableView: tableView) })
        }
    }
    
    @objc
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer< CGPoint >) {
        let tableView = self.tableView!
        var targetContentOffsets: [CGPoint] = []
        self._observer.notify({
            if let contentOffset = $0.finishScroll(self, tableView: tableView, velocity: velocity) {
                targetContentOffsets.append(contentOffset)
            }
        })
        if targetContentOffsets.count > 0 {
            var avgTargetContentOffset = targetContentOffsets.first!
            if targetContentOffsets.count > 1 {
                for nextTargetContentOffset in targetContentOffsets {
                    avgTargetContentOffset = CGPoint(
                        x: (avgTargetContentOffset.x + nextTargetContentOffset.x) / 2,
                        y: (avgTargetContentOffset.y + nextTargetContentOffset.y) / 2
                    )
                }
            }
            targetContentOffset.pointee = avgTargetContentOffset
        }
    }
    
    @objc
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let tableView = self.tableView!
        self._observer.notify({ $0.endScroll(self, tableView: tableView) })
    }
    
    @objc
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    }

}

// MARK: UITableViewDataSource

extension QTableController : UITableViewDataSource {

    @objc
    open func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return self.sections.count
    }

    @objc
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

    @objc
    open func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let row = self.row(indexPath: indexPath)
        let cell = self.dequeue(row: row, indexPath: indexPath).unsafelyUnwrapped
        cell.prepare(any: row, spec: tableView as! TableView, animated: false)
        return cell
    }

    @objc
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

    @objc
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

// MARK: UITableViewDelegate

extension QTableController : UITableViewDelegate {

    @objc
    open func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        if let data = self.header(index: section) {
            if let decorClass = self._decorClass(data: data) {
                let decor = decorClass.dequeue(tableView: tableView).unsafelyUnwrapped
                decor.prepare(any: data, spec: tableView as! TableView, animated: false)
                return decor
            }
        }
        return nil
    }

    @objc
    open func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        if let data = self.footer(index: section) {
            if let decorClass = self._decorClass(data: data) {
                let decor = decorClass.dequeue(tableView: tableView).unsafelyUnwrapped
                decor.prepare(any: data, spec: tableView as! TableView, animated: false)
                return decor
            }
        }
        return nil
    }

    @objc
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = self.row(indexPath: indexPath)
        self.visibleCells.append(cell)
        self._updateVisibleIndexPaths(tableView)
        if let cell = cell as? IQTableCell {
            cell.beginDisplay()
        }
        row.cacheHeight = cell.frame.height
    }

    @objc
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let index = self.visibleCells.firstIndex(where: { return $0 === cell }) {
            self.visibleCells.remove(at: index)
        }
        self._updateVisibleIndexPaths(tableView)
        if let cell = cell as? IQTableCell {
            cell.endDisplay()
        }
    }

    @objc
    open func tableView(
        _ tableView: UITableView,
        willDisplayHeaderView view: UIView,
        forSection section: Int
    ) {
        guard let data = self.header(index: section) else { return }
        if let decorView = view as? IQTableDecor {
            decorView.beginDisplay()
        }
        data.cacheHeight = view.frame.height
    }

    @objc
    open func tableView(
        _ tableView: UITableView,
        didEndDisplayingHeaderView view: UIView,
        forSection section: Int
    ) {
        if let decorView = view as? IQTableDecor {
            decorView.endDisplay()
        }
    }

    @objc
    open func tableView(
        _ tableView: UITableView,
        willDisplayFooterView view: UIView,
        forSection section: Int
    ) {
        guard let data = self.footer(index: section) else { return }
        if let decorView = view as? IQTableDecor {
            decorView.beginDisplay()
        }
        data.cacheHeight = view.frame.height
    }

    @objc
    open func tableView(
        _ tableView: UITableView,
        didEndDisplayingFooterView view: UIView,
        forSection section: Int
    ) {
        if let decorView = view as? IQTableDecor {
            decorView.endDisplay()
        }
    }

    @objc
    open func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let row = self.row(indexPath: indexPath)
        if let cacheHeight = row.cacheHeight {
            return cacheHeight
        }
        var caclulatedHeight: CGFloat = 0
        if let cellClass = self._cellClass(row: row) {
            caclulatedHeight = cellClass.height(any: row, spec: tableView as! TableView)
        } else {
            caclulatedHeight = 0
        }
        if caclulatedHeight != UITableView.automaticDimension {
            row.cacheHeight = caclulatedHeight
        }
        return caclulatedHeight
    }

    @objc
    open func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        guard let data = self.header(index: section) else { return 0 }
        if let cacheHeight = data.cacheHeight {
            return cacheHeight
        }
        var caclulatedHeight: CGFloat = 0
        if let decorClass = self._decorClass(data: data) {
            caclulatedHeight = decorClass.height(any: data, spec: tableView as! TableView)
        } else {
            caclulatedHeight = 0
        }
        if caclulatedHeight != UITableView.automaticDimension {
            data.cacheHeight = caclulatedHeight
        }
        return caclulatedHeight
    }

    @objc
    open func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        guard let data = self.footer(index: section) else { return 0 }
        if let cacheHeight = data.cacheHeight {
            return cacheHeight
        }
        var caclulatedHeight: CGFloat = 0
        if let decorClass = self._decorClass(data: data) {
            caclulatedHeight = decorClass.height(any: data, spec: tableView as! TableView)
        } else {
            caclulatedHeight = 0
        }
        if caclulatedHeight != UITableView.automaticDimension {
            data.cacheHeight = caclulatedHeight
        }
        return caclulatedHeight
    }
    
    @objc
    open func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        let row = self.row(indexPath: indexPath)
        return row.cacheHeight ?? self.estimatedRowHeight
    }
    
    @objc
    open func tableView(
        _ tableView: UITableView,
        estimatedHeightForHeaderInSection section: Int
    ) -> CGFloat {
        guard let data = self.header(index: section) else { return self.estimatedSectionFooterHeight }
        return data.cacheHeight ?? self.estimatedSectionFooterHeight
    }
    
    @objc
    open func tableView(
        _ tableView: UITableView,
        estimatedHeightForFooterInSection section: Int
    ) -> CGFloat {
        guard let data = self.footer(index: section) else { return self.estimatedSectionFooterHeight }
        return data.cacheHeight ?? self.estimatedSectionFooterHeight
    }

    @objc
    open func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath
    ) -> Bool {
        let row = self.row(indexPath: indexPath)
        return row.canSelect
    }

    @objc
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

    @objc
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

    @objc
    open func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        let row = self.row(indexPath: indexPath)
        return row.editingStyle
    }
    
    @objc
    @available(iOS 11.0, *)
    open func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let row = self.row(indexPath: indexPath)
        return row.leadingSwipeConfiguration
    }
    
    @objc
    @available(iOS 11.0, *)
    open func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let row = self.row(indexPath: indexPath)
        return row.trailingSwipeConfiguration
    }

}
