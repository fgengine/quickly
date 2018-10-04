//
//  Quickly
//

open class QSpaceTableRow : QBackgroundColorTableRow {

    public var size: CGFloat

    public init(size: CGFloat, backgroundColor: UIColor? = nil) {
        self.size = size
        super.init(backgroundColor: backgroundColor)
        self.canSelect = false
    }

}

open class QSpaceTableCell< RowType: QSpaceTableRow >: QBackgroundColorTableCell< RowType > {

    open override class func height(row: RowType, spec: IQContainerSpec) -> CGFloat {
        return row.size
    }

}
