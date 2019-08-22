//
//  Quickly
//

open class QPickerSection : IQPickerSection {

    public typealias CellType = IQPickerSection.CellType

    public weak var controller: IQPickerController?
    public var cellType: CellType {
        didSet { self._reloadColumn() }
    }
    public var size: CGSize {
        didSet { self._reloadColumn() }
    }
    public private(set) var index: Int?

    public var rows: [IQPickerRow] {
        willSet { self._unbindRows() }
        didSet {
            self._rebindRows(from: self.rows.startIndex, to: self.rows.endIndex)
            self._reloadColumn()
        }
    }

    public init(cellType: CellType, size: CGSize, rows: [IQPickerRow]) {
        self.cellType = cellType
        self.size = size
        self.rows = rows
    }

    public convenience init(cellType: CellType, height: CGFloat, rows: [IQPickerRow]) {
        self.init(cellType: cellType, size: CGSize(width: 0, height: height), rows: rows)
    }

    public func bind(_ controller: IQPickerController, _ index: Int) {
        self.controller = controller
        self.index = index
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
        self._unbindRows()
        self.index = nil
        self.controller = nil
    }

    public func insertRow(_ rows: [IQPickerRow], index: Int) {
        self.rows.insert(contentsOf: rows, at: index)
        self._rebindRows(from: index, to: self.rows.endIndex)
        self._reloadColumn()
    }

    public func deleteRow(_ rows: [IQPickerRow]) {
        var indices: [Int] = []
        for row in rows {
            if let index = self.rows.firstIndex(where: { return ($0 === row) }) {
                indices.append(index)
            }
        }
        if indices.count > 0 {
            indices.sort()
            for index in indices.reversed() {
                let row = self.rows[index]
                self.rows.remove(at: index)
                row.unbind()
            }
            self._rebindRows(from: indices.first!, to: self.rows.endIndex)
            self._reloadColumn()
        }
    }

}

extension QPickerSection {

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

    private func _reloadColumn() {
        guard
            let index = self.index,
            let controller = self.controller,
            let pickerView = controller.pickerView
            else { return }
        if controller.isBatchUpdating == false {
            pickerView.reloadComponent(index)
        }
    }

}
