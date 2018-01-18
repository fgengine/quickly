//
//  Quickly
//

#if os(iOS)

    public protocol IQCollectionController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        weak var collectionView: UICollectionView? { set get }
        var sections: [IQCollectionSection] { set get }
        var items: [IQCollectionItem] { get }
        var selectedItems: [IQCollectionItem] { get }
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

        func prependSection(_ section: IQCollectionSection)
        func prependSection(_ sections: [IQCollectionSection])
        func appendSection(_ section: IQCollectionSection)
        func appendSection(_ sections: [IQCollectionSection])
        func insertSection(_ section: IQCollectionSection, index: Int)
        func insertSection(_ sections: [IQCollectionSection], index: Int)
        func deleteSection(_ section: IQCollectionSection)
        func deleteSection(_ sections: [IQCollectionSection])
        func reloadSection(_ section: IQCollectionSection)
        func reloadSection(_ sections: [IQCollectionSection])

        func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)?)

        func scroll(item: IQCollectionItem, scroll: UICollectionViewScrollPosition, animated: Bool)

        func isSelected(item: IQCollectionItem) -> Bool
        func select(item: IQCollectionItem, scroll: UICollectionViewScrollPosition, animated: Bool)
        func deselect(item: IQCollectionItem, animated: Bool)

        func update(header: IQCollectionData, kind: String)
        func update(footer: IQCollectionData, kind: String)
        func update(item: IQCollectionItem)

    }
    
    public extension IQCollectionController {
        
        public func prependSection(_ section: IQCollectionSection) {
            self.insertSection([ section ], index: self.sections.startIndex)
        }
        
        public func prependSection(_ sections: [IQCollectionSection]) {
            self.insertSection(sections, index: self.sections.startIndex)
        }
        
        public func appendSection(_ section: IQCollectionSection) {
            self.insertSection([ section ], index: self.sections.endIndex)
        }
        
        public func appendSection(_ sections: [IQCollectionSection]) {
            self.insertSection(sections, index: self.sections.endIndex)
        }
        
        public func insertSection(_ section: IQCollectionSection, index: Int) {
            self.insertSection([ section ], index: index)
        }
        
        public func deleteSection(_ section: IQCollectionSection) {
            self.deleteSection([ section ])
        }
        
        public func reloadSection(_ section: IQCollectionSection) {
            self.reloadSection([ section ])
        }
        
    }

#endif

