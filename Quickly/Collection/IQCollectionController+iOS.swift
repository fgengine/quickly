//
//  Quickly
//

#if os(iOS)

    public protocol IQCollectionController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        weak var collectionView: UICollectionView? { set get }
        var sections: [IQCollectionSection] { set get }
        var items: [IQCollectionItem] { get }
        var canMove: Bool { get }

        func configure()

        func section(index: Int) -> IQCollectionSection
        func index(section: IQCollectionSection) -> Int?

        func header(index: Int) -> IQCollectionData?
        func index(header: IQCollectionData) -> Int?

        func footer(index: Int) -> IQCollectionData?
        func index(footer: IQCollectionData) -> Int?

        func item(indexPath: IndexPath) -> IQCollectionItem
        func item(predicate: (IQCollectionItem) -> Bool) -> IQCollectionItem?

        func indexPath(item: IQCollectionItem) -> IndexPath?
        func indexPath(predicate: (IQCollectionItem) -> Bool) -> IndexPath?

        func dequeue(data: IQCollectionData, kind: String, indexPath: IndexPath) -> IQCollectionDecor?
        func dequeue(item: IQCollectionItem, indexPath: IndexPath) -> IQCollectionCell?

        func reload()

        func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?)

        func scroll(item: IQCollectionItem, scroll: UICollectionViewScrollPosition, animated: Bool)

        func isSelected(item: IQCollectionItem) -> Bool
        func select(item: IQCollectionItem, scroll: UICollectionViewScrollPosition, animated: Bool)
        func deselect(item: IQCollectionItem, animated: Bool)

        func update(header: IQCollectionData, kind: String)
        func update(footer: IQCollectionData, kind: String)
        func update(item: IQCollectionItem)

    }

#endif

