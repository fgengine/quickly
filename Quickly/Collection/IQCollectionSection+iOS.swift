//
//  Quickly
//

#if os(iOS)

    public protocol IQCollectionSection: class {

        var insets: UIEdgeInsets { get }
        var minimumLineSpacing: CGFloat { get }
        var minimumInteritemSpacing: CGFloat { get }

        var canMove: Bool { get }
        var hidden: Bool { get }

        var header: IQCollectionData? { get }
        var footer: IQCollectionData? { get }
        var items: [IQCollectionItem] { get }

        func insertItem(_ item: IQCollectionItem, index: Int)
        func deleteItem(_ index: Int) -> IQCollectionItem?
        func moveItem(_ fromIndex: Int, toIndex: Int)

    }

#endif
