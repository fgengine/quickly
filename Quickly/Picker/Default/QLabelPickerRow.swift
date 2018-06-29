//
//  Quickly
//

open class QLabelPickerRow : QPickerRow {

    public var edgeInsets: UIEdgeInsets
    public var label: QLabelStyleSheet

    public init(label: QLabelStyleSheet, edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)) {
        self.edgeInsets = edgeInsets
        self.label = label

        super.init()
    }

}
