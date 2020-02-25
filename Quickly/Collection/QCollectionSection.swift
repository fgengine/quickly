//
//  Quickly
//

open class QCollectionSection : IQCollectionSection {

    public private(set) weak var controller: IQCollectionController?
    public private(set) var index: Int?
    public var insets: UIEdgeInsets? {
        didSet { self._reloadSection() }
    }
    public var minimumLineSpacing: CGFloat? {
        didSet { self._reloadSection() }
    }
    public var minimumInteritemSpacing: CGFloat? {
        didSet { self._reloadSection() }
    }
    public var canMove: Bool = true {
        didSet { self._reloadSection() }
    }
    public var hidden: Bool = false {
        didSet { self._reloadSection() }
    }

    public var header: IQCollectionData? {
        willSet { self._unbindHeader() }
        didSet {
            self._bindHeader()
            self._reloadSection()
        }
    }
    public var footer: IQCollectionData? {
        willSet { self._unbindFooter() }
        didSet {
            self._bindFooter()
            self._reloadSection()
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
        self._bindHeader()
        self._bindFooter()
        self._bindItems()
    }
    
    public func unbind() {
        self._unbindHeader()
        self._unbindFooter()
        for item in self.items {
            item.unbind()
        }
        self.index = nil
        self.controller = nil
    }
    
    public func setItems(_ items: [IQCollectionItem]) {
        self._unbindItems()
        self.items = items
        self._bindItems()
    }
    
    public func insertItem(_ items: [IQCollectionItem], index: Int) {
        self.items.insert(contentsOf: items, at: index)
        self._bindItems(from: index, to: self.items.endIndex)
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
            if let index = self.items.firstIndex(where: { return ($0 === item) }) {
                indices.append(index)
            }
        }
        if indices.count > 0 {
            indices.sort()
            let indexPaths = items.compactMap({ $0.indexPath })
            for index in indices.reversed() {
                let item = self.items[index]
                self.items.remove(at: index)
                item.unbind()
            }
            self._bindItems(from: indices.first!, to: self.items.endIndex)
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
        self._bindItems(
            from: min(fromIndex, toIndex),
            to: max(fromIndex, toIndex)
        )
    }

}

// MARK: Private

private extension QCollectionSection {
    
    func _bindHeader() {
        if let header = self.header {
            header.bind(self)
        }
    }
    
    func _unbindHeader() {
        if let header = self.header {
            header.unbind()
        }
    }
    
    func _bindFooter() {
        if let footer = self.header {
            footer.bind(self)
        }
    }
    
    func _unbindFooter() {
        if let footer = self.header {
            footer.unbind()
        }
    }
    
    func _bindItems() {
        guard let sectionIndex = self.index else { return }
        var itemIndex = 0
        for item in self.items {
            item.bind(self, IndexPath(item: itemIndex, section: sectionIndex))
            itemIndex += 1
        }
    }
    
    func _bindItems(from: Int, to: Int) {
        guard let sectionIndex = self.index else { return }
        for itemIndex in from..<to {
            self.items[itemIndex].bind(self, IndexPath(item: itemIndex, section: sectionIndex))
        }
    }
    
    func _unbindItems() {
        for item in self.items {
            item.unbind()
        }
    }

    func _reloadSection() {
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
