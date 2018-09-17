//
//  Quickly
//

open class QCollectionSection : IQCollectionSection {

    public weak var controller: IQCollectionController?
    public private(set) var index: Int?
    public var insets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet { self.reloadSection() }
    }
    public var minimumLineSpacing: CGFloat = 0 {
        didSet { self.reloadSection() }
    }
    public var minimumInteritemSpacing: CGFloat = 0 {
        didSet { self.reloadSection() }
    }
    public var canMove: Bool = true {
        didSet { self.reloadSection() }
    }
    public var hidden: Bool = false {
        didSet { self.reloadSection() }
    }

    public var header: IQCollectionData? {
        willSet { self.unbindHeader() }
        didSet {
            self.bindHeader()
            self.reloadSection()
        }
    }
    public var footer: IQCollectionData? {
        willSet { self.unbindFooter() }
        didSet {
            self.bindFooter()
            self.reloadSection()
        }
    }
    public private(set) var items: [IQCollectionItem]
    
    public init(items: [IQCollectionItem]) {
        self.header = nil
        self.footer = nil
        self.items = items
    }

    public init(header: IQCollectionData, items: [IQCollectionItem]) {
        self.header = header
        self.footer = nil
        self.items = items
    }

    public init(footer: IQCollectionData, items: [IQCollectionItem]) {
        self.header = nil
        self.footer = footer
        self.items = items
    }

    public init(header: IQCollectionData, footer: IQCollectionData, items: [IQCollectionItem]) {
        self.header = header
        self.footer = footer
        self.items = items
    }
    
    public func bind(_ controller: IQCollectionController, _ index: Int) {
        self.controller = controller
        self.index = index
        self.bindHeader()
        self.bindFooter()
        self.bindItems()
    }
    
    public func rebind(_ index: Int) {
        self.index = index
        self.rebindItems(
            from: self.items.startIndex,
            to: self.items.endIndex
        )
    }
    
    public func unbind() {
        self.unbindHeader()
        self.unbindFooter()
        for item in self.items {
            item.unbind()
        }
        self.index = nil
        self.controller = nil
    }
    
    public func setItems(_ items: [IQCollectionItem]) {
        self.items = items
    }
    
    public func insertItem(_ items: [IQCollectionItem], index: Int) {
        self.items.insert(contentsOf: items, at: index)
        self.rebindItems(from: index, to: self.items.endIndex)
        let indexPaths = items.compactMap({ $0.indexPath })
        if indexPaths.count > 0 {
            if let controller = self.controller, let collectionView = controller.collectionView {
                collectionView.insertItems(at: indexPaths)
            }
        }
    }
    
    public func deleteItem(_ items: [IQCollectionItem]) {
        var indices: [Int] = []
        for item in items {
            if let index = self.items.index(where: { return ($0 === item) }) {
                indices.append(index)
            }
        }
        if indices.count > 0 {
            let indexPaths = items.compactMap({ $0.indexPath })
            for index in indices.reversed() {
                let item = self.items[index]
                self.items.remove(at: index)
                item.unbind()
            }
            self.rebindItems(from: indices.first!, to: self.items.endIndex)
            if indexPaths.count > 0 {
                if let controller = self.controller, let collectionView = controller.collectionView {
                    collectionView.deleteItems(at: indexPaths)
                }
            }
        }
    }
    
    public func reloadItem(_ items: [IQCollectionItem]) {
        let indexPaths = items.compactMap({ return $0.indexPath })
        if indexPaths.count > 0 {
            if let controller = self.controller, let collectionView = controller.collectionView {
                collectionView.reloadItems(at: indexPaths)
            }
        }
    }

    public func replaceItem(_ item: IQCollectionItem, index: Int) {
        self.items[index] = item
        if let indexPath = item.indexPath, let controller = self.controller, let collectionView = controller.collectionView {
            collectionView.reloadItems(at: [ indexPath ])
        }
    }
    
    public func moveItem(_ fromIndex: Int, toIndex: Int) {
        let item = self.items[fromIndex]
        self.items.remove(at: fromIndex)
        self.items.insert(item, at: toIndex)
        self.rebindItems(
            from: min(fromIndex, toIndex),
            to: max(fromIndex, toIndex)
        )
    }

}

extension QCollectionSection {
    
    private func bindHeader() {
        if let header = self.header {
            header.bind(self)
        }
    }
    
    private func unbindHeader() {
        if let header = self.header {
            header.unbind()
        }
    }
    
    private func bindFooter() {
        if let footer = self.header {
            footer.bind(self)
        }
    }
    
    private func unbindFooter() {
        if let footer = self.header {
            footer.unbind()
        }
    }
    
    private func bindItems() {
        guard let sectionIndex = self.index else { return }
        var itemIndex = 0
        for item in self.items {
            item.bind(self, IndexPath(item: itemIndex, section: sectionIndex))
            itemIndex += 1
        }
    }
    
    private func rebindItems(from: Int, to: Int) {
        guard let sectionIndex = self.index else { return }
        for itemIndex in from..<to {
            self.items[itemIndex].rebind(IndexPath(item: itemIndex, section: sectionIndex))
        }
    }
    
    private func unbindItems() {
        for item in self.items {
            item.unbind()
        }
    }

    private func reloadSection() {
        guard
            let index = self.index,
            let controller = self.controller,
            let collectionView = controller.collectionView
            else { return }
        if controller.isBatchUpdating == false {
            collectionView.reloadSections(IndexSet(integer: index))
        }
    }
    
}
