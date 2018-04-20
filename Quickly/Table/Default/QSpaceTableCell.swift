//
//  Quickly
//

open class QSpaceTableRow : QBackgroundColorTableRow {

    public var size: CGFloat

    public init(_ size: CGFloat) {
        self.size = size
        super.init()
    }

}

open class QSpaceTableCell< RowType: QSpaceTableRow >: QBackgroundColorTableCell< RowType > {

    open override class func height(row: RowType, width: CGFloat) -> CGFloat {
        return row.size
    }

}
