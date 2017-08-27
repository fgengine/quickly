//
//  Quickly
//

import UIKit

open class QTableRow: IQTableRow {

    public var canSelect: Bool = true
    public var canEdit: Bool = false
    public var canMove: Bool = false
    public var selectionStyle: UITableViewCellSelectionStyle = .default
    public var editingStyle: UITableViewCellEditingStyle = .none

}
