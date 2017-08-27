//
//  Quickly
//

import UIKit

open class QTableSection: ITableSection {

    public var canEdit: Bool = true
    public var canMove: Bool = true
    public var hidden: Bool = false

    public var header: IQTableData?
    public var footer: IQTableData?
    public var rows: [IQTableRow]

    public init(rows: [IQTableRow]) {
        self.header = nil
        self.footer = nil
        self.rows = rows
    }

    public init(header: IQTableData, rows: [IQTableRow]) {
        self.header = header
        self.footer = nil
        self.rows = rows
    }

    public init(footer: IQTableData, rows: [IQTableRow]) {
        self.header = nil
        self.footer = footer
        self.rows = rows
    }

    public init(header: IQTableData, footer: IQTableData, rows: [IQTableRow]) {
        self.header = header
        self.footer = footer
        self.rows = rows
    }

    public func insertRow(_ row: IQTableRow, index: Int) {
        self.rows.insert(row, at: index)
    }

    public func deleteRow(_ index: Int) -> IQTableRow? {
        if index >= self.rows.count {
            return nil
        }
        let row = self.rows[index]
        self.rows.remove(at: index)
        return row
    }

    public func moveRow(_ fromIndex: Int, toIndex: Int) {
        let row = self.rows[fromIndex]
        self.rows.remove(at: fromIndex)
        self.rows.insert(row, at: toIndex)
    }

} 
