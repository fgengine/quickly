//
//  Quickly
//

open class QLabelTableRow : QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets

    public var label: QLabelStyleSheet

    public init(label: QLabelStyleSheet) {
        self.edgeInsets = UIEdgeInsets.zero
        self.label = label

        super.init()
    }

}
