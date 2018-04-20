//
//  Quickly
//

open class QPickerSection : IQPickerSection {

    public typealias CellType = IQPickerSection.CellType

    public weak var controller: IQPickerController?
    public var cellType: CellType {
        didSet { self.reloadColumn() }
    }
    public var size: CGSize {
        didSet { self.reloadColumn() }
    }
    public private(set) var index: Int?

    public var rows: [IQPickerRow] {
        willSet { self.unbind() }
        didSet {
            self.rebindRows(from: self.rows.startIndex, to: self.rows.endIndex)
            self.reloadColumn()
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
        self.unbindRows()
        self.index = nil
        self.controller = nil
    }

    public func insertRow(_ rows: [IQPickerRow], index: Int) {
        self.rows.insert(contentsOf: rows, at: index)
        self.rebindRows(from: index, to: self.rows.endIndex)
        self.reloadColumn()
    }

    public func deleteRow(_ rows: [IQPickerRow]) {
        var indices: [Int] = []
        for row in rows {
            if let index = self.rows.index(where: { return ($0 === row) }) {
                indices.append(index)
            }
        }
        if indices.count > 0 {
            for index in indices.reversed() {
                let row = self.rows[index]
                self.rows.remove(at: index)
                row.unbind()
            }
            self.rebindRows(from: indices.first!, to: self.rows.endIndex)
            self.reloadColumn()
        }
    }

}

extension QPickerSection {

    private func bindRows() {
        guard let sectionIndex = self.index else { return }
        var rowIndex: Int = 0
        for row in self.rows {
            row.bind(self, IndexPath(row: rowIndex, section: sectionIndex))
            rowIndex += 1
        }
    }

    private func rebindRows(from: Int, to: Int) {
        guard let sectionIndex = self.index else { return }
        for rowIndex in from..<to {
            self.rows[rowIndex].rebind(IndexPath(row: rowIndex, section: sectionIndex))
        }
    }

    private func unbindRows() {
        for row in self.rows {
            row.unbind()
        }
    }

    private func reloadColumn() {
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
