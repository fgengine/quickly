//
//  Quickly
//

open class QTitleValueTableRow : QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var value: QLabelStyleSheet

    public init(title: QLabelStyleSheet, value: QLabelStyleSheet) {
        self.edgeInsets = UIEdgeInsets.zero
        self.title = title
        self.titleSpacing = 0
        self.value = value

        super.init()
    }

}
