//
//  Quickly
//

#if os(iOS)

    public class QSpaceTableCell< RowType: QSpaceTableRow >: QBackgroundColorTableCell< RowType > {

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            return row.size
        }

    }

#endif
