//
//  Quickly
//

#if os(iOS)

    open class QCollectionSection: IQCollectionSection {

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

        public var insets: UIEdgeInsets = UIEdgeInsets.zero
        public var minimumLineSpacing: CGFloat = 0
        public var minimumInteritemSpacing: CGFloat = 0
        public var canMove: Bool = true
        public var hidden: Bool = false

        public var header: IQCollectionData?
        public var footer: IQCollectionData?
        public var items: [IQCollectionItem]

        public func insertItem(_ item: IQCollectionItem, index: Int) {
            self.items.insert(item, at: index)
        }

        public func deleteItem(_ index: Int) -> IQCollectionItem? {
            if index >= self.items.count {
                return nil
            }
            let item: IQCollectionItem = self.items[index]
            self.items.remove(at: index)
            return item
        }

        public func moveItem(_ fromIndex: Int, toIndex: Int) {
            let item: IQCollectionItem = self.items[fromIndex]
            self.items.remove(at: fromIndex)
            self.items.insert(item, at: toIndex)
        }

    }

#endif

