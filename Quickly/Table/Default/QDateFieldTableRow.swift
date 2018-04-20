//
//  Quickly
//

open class QDateFieldTableRow : QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets

    public var field: QDateFieldStyleSheet
    public var fieldHeight: CGFloat
    public var fieldDate: Date?
    public var fieldIsValid: Bool
    public var fieldIsEditing: Bool

    public init(field: QDateFieldStyleSheet, date: Date?) {
        self.edgeInsets = UIEdgeInsets.zero
        self.field = field
        self.fieldHeight = 44
        self.fieldDate = date
        self.fieldIsValid = true
        self.fieldIsEditing = false

        super.init()
    }

}
