//
//  Quickly
//

open class QSeparatorTableRow : QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero

    public var color: UIColor

    public init(_ color: UIColor) {
        self.color = color
        super.init()
    }


}
