//
//  Quickly
//

#if os(iOS)

    public enum QCollectionTableRowSizeBehaviour {
        case fixed(size: CGFloat)
        case dynamic
    }

    open class QCollectionTableRow : QBackgroundColorTableRow {

        public typealias LayoutType = UICollectionViewLayout & IQCollectionLayout

        public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero

        public var sizeBehaviour: QCollectionTableRowSizeBehaviour = .dynamic
        public var controller: IQCollectionController
        public var layout: LayoutType

        public init(_ controller: IQCollectionController, layout: LayoutType) {
            self.controller = controller
            self.layout = layout
            super.init()
        }


    }

#endif
