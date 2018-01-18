//
//  Quickly
//

#if os(iOS)

    open class QCollectionSection: IQCollectionSection {

        public weak var controller: IQCollectionController? = nil
        public private(set) var index: Int? = nil
        public var insets: UIEdgeInsets = UIEdgeInsets.zero
        public var minimumLineSpacing: CGFloat = 0
        public var minimumInteritemSpacing: CGFloat = 0
        public var canMove: Bool = true
        public var hidden: Bool = false
        
        public var header: IQCollectionData?
        public var footer: IQCollectionData?
        public var items: [IQCollectionItem]
        
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
            for item: IQCollectionItem in self.items {
                item.unbind()
            }
            self.index = nil
            self.controller = nil
        }
        
        public func insertItem(_ items: [IQCollectionItem], index: Int) {
            self.items.insert(contentsOf: items, at: index)
            self.rebindItems(from: index, to: self.items.endIndex)
            let indexPaths: [IndexPath] = items.flatMap({ (item: IQCollectionItem) -> IndexPath? in
                return item.indexPath
            })
            if indexPaths.count > 0 {
                if let controller: IQCollectionController = self.controller, let collectionView: UICollectionView = controller.collectionView {
                    collectionView.insertItems(at: indexPaths)
                }
            }
        }
        
        public func deleteItem(_ items: [IQCollectionItem]) {
            var indices: [Int] = []
            for item: IQCollectionItem in items {
                if let index: Int = self.items.index(where: { (existItem: IQCollectionItem) -> Bool in
                    return (existItem === item)
                }) {
                    indices.append(index)
                }
            }
            if indices.count > 0 {
                let indexPaths: [IndexPath] = items.flatMap({ (item: IQCollectionItem) -> IndexPath? in
                    return item.indexPath
                })
                for index: Int in indices.reversed() {
                    let item: IQCollectionItem = self.items[index]
                    self.items.remove(at: index)
                    item.unbind()
                }
                self.rebindItems(from: indices.first!, to: self.items.endIndex)
                if indexPaths.count > 0 {
                    if let controller: IQCollectionController = self.controller, let collectionView: UICollectionView = controller.collectionView {
                        collectionView.deleteItems(at: indexPaths)
                    }
                }
            }
        }
        
        public func reloadItem(_ items: [IQCollectionItem]) {
            let indexPaths: [IndexPath] = items.flatMap({ (item: IQCollectionItem) -> IndexPath? in
                return item.indexPath
            })
            if indexPaths.count > 0 {
                if let controller: IQCollectionController = self.controller, let collectionView: UICollectionView = controller.collectionView {
                    collectionView.reloadItems(at: indexPaths)
                }
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
            if let header: IQCollectionData = self.header {
                header.bind(self)
            }
        }
        
        private func unbindHeader() {
            if let header: IQCollectionData = self.header {
                header.unbind()
            }
        }
        
        private func bindFooter() {
            if let footer: IQCollectionData = self.header {
                footer.bind(self)
            }
        }
        
        private func unbindFooter() {
            if let footer: IQCollectionData = self.header {
                footer.unbind()
            }
        }
        
        private func bindItems() {
            guard let sectionIndex: Int = self.index else { return }
            var itemIndex: Int = 0
            for item: IQCollectionItem in self.items {
                item.bind(self, IndexPath(item: itemIndex, section: sectionIndex))
                itemIndex += 1
            }
        }
        
        private func rebindItems(from: Int, to: Int) {
            guard let sectionIndex: Int = self.index else { return }
            for itemIndex: Int in from..<to {
                self.items[itemIndex].rebind(IndexPath(item: itemIndex, section: sectionIndex))
            }
        }
        
        private func unbindItems() {
            for item: IQCollectionItem in self.items {
                item.unbind()
            }
        }
        
    }

#endif

