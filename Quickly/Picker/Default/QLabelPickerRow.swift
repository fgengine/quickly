//
//  Quickly
//

open class QLabelPickerRow : QPickerRow {

    public var edgeInsets: UIEdgeInsets

    public var label: QLabelStyleSheet

    public init(label: QLabelStyleSheet) {
        self.edgeInsets = UIEdgeInsets.zero
        self.label = label

        super.init()
    }

}
