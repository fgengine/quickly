//
//  Quickly
//

open class QListFieldTableRow : QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets

    public var field: QListFieldStyleSheet
    public var fieldHeight: CGFloat
    public var fieldSelectedRow: QListFieldPickerRow?
    public var fieldIsValid: Bool
    public var fieldIsEditing: Bool

    public init(field: QListFieldStyleSheet, text: String) {
        self.edgeInsets = UIEdgeInsets.zero
        self.field = field
        self.fieldHeight = 44
        self.fieldIsValid = true
        self.fieldIsEditing = false

        super.init()
    }

}
