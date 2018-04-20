//
//  Quickly
//

open class QTitleDetailTableRow : QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var detail: QLabelStyleSheet

    public init(title: QLabelStyleSheet, detail: QLabelStyleSheet) {
        self.edgeInsets = UIEdgeInsets.zero
        self.title = title
        self.titleSpacing = 0
        self.detail = detail

        super.init()
    }

}
