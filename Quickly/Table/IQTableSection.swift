//
//  Quickly
//

import UIKit

public protocol IQTableSection: class {

    var canEdit: Bool { get }
    var canMove: Bool { get }
    var hidden: Bool { get }

    var header: IQTableData? { get }
    var footer: IQTableData? { get }
    var rows: [IQTableRow] { get }

    func insertRow(_ row: IQTableRow, index: Int)
    func deleteRow(_ index: Int) -> IQTableRow?
    func moveRow(_ fromIndex: Int, toIndex: Int)

}
