//
//  Quickly
//

open class QListFieldPickerRow : QPickerRow {

    public var field: QLabelStyleSheet
    public var row: QLabelStyleSheet
    public var rowEdgeInsets: UIEdgeInsets

    public init(
        field: QLabelStyleSheet,
        row: QLabelStyleSheet,
        rowEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    ) {
        self.field = field
        self.row = row
        self.rowEdgeInsets = rowEdgeInsets

        super.init()
    }

}
