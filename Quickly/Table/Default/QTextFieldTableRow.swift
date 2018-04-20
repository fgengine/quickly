//
//  Quickly
//

open class QTextFieldTableRow : QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets

    public var field: QTextFieldStyleSheet
    public var fieldHeight: CGFloat
    public var fieldText: String
    public var fieldIsValid: Bool
    public var fieldIsEditing: Bool

    public init(field: QTextFieldStyleSheet, text: String) {
        self.edgeInsets = UIEdgeInsets.zero
        self.field = field
        self.fieldHeight = 44
        self.fieldText = text
        self.fieldIsValid = true
        self.fieldIsEditing = false

        super.init()
    }

}
