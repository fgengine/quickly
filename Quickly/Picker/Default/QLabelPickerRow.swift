//
//  Quickly
//

open class QLabelPickerRow : QPickerRow {

    public var edgeInsets: UIEdgeInsets
    public var label: QLabelStyleSheet

    public init(label: QLabelStyleSheet, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero) {
        self.edgeInsets = edgeInsets
        self.label = label

        super.init()
    }

}
