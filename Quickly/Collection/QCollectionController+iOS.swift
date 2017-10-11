//
//  Quickly
//

#if os(iOS)

    open class QCollectionController: NSObject, IQCollectionController, CollectionCellDelegate, IQCollectionDecorDelegate {

        public weak var collectionView: UICollectionView? = nil {
            didSet {
                self.configure()
            }
        }
        public var sections: [IQCollectionSection] = []
        public var items: [IQCollectionItem] {
            get {
                return self.sections.flatMap({ (section: IQCollectionSection) -> [IQCollectionItem] in
                    return section.items
                })
            }
        }
        public var canMove: Bool = true
        private var decors: [IQCollectionDecor.Type]
        private var cells: [IQCollectionCell.Type]

        public init(
            cells: [IQCollectionCell.Type]
        ) {
            self.decors = []
            self.cells = cells
            super.init()
        }

        public init(
            decors: [IQCollectionDecor.Type],
            cells: [IQCollectionCell.Type]
        ) {
            self.decors = decors
            self.cells = cells
            super.init()
        }

        fileprivate func decorClass(data: IQCollectionData) -> IQCollectionDecor.Type? {
            return self.decors.first(where: { (decor: IQCollectionDecor.Type) -> Bool in
                return decor.using(any: data)
            })
        }

        fileprivate func cellClass(item: IQCollectionItem) -> IQCollectionCell.Type? {
            return self.cells.first(where: { (cell: IQCollectionCell.Type) -> Bool in
                return cell.using(any: item)
            })
        }

        open func configure() {
            if let collectionView: UICollectionView = self.collectionView {
                for type: IQCollectionDecor.Type in self.decors {
                    type.register(collectionView: collectionView, kind: UICollectionElementKindSectionHeader)
                    type.register(collectionView: collectionView, kind: UICollectionElementKindSectionFooter)
                }
                for type: IQCollectionCell.Type in self.cells {
                    type.register(collectionView: collectionView)
                }
            }
            self.reload()
        }

        public func section(index: Int) -> IQCollectionSection {
            return self.sections[index]
        }

        public func index(section: IQCollectionSection) -> Int? {
            return self.sections.index { (existSection: IQCollectionSection) -> Bool in
                return existSection === section
            }
        }

        public func header(index: Int) -> IQCollectionData? {
            return self.sections[index].header
        }

        public func index(header: IQCollectionData) -> Int? {
            return self.sections.index(where: { (existSection: IQCollectionSection) -> Bool in
                return existSection.header === header
            })
        }

        public func footer(index: Int) -> IQCollectionData? {
            return self.sections[index].footer
        }

        public func index(footer: IQCollectionData) -> Int? {
            return self.sections.index(where: { (existSection: IQCollectionSection) -> Bool in
                return existSection.footer === footer
            })
        }

        public func item(indexPath: IndexPath) -> IQCollectionItem {
            return self.sections[indexPath.section].items[indexPath.item]
        }

        public func item(predicate: (IQCollectionItem) -> Bool) -> IQCollectionItem? {
            for section: IQCollectionSection in self.sections {
                for item: IQCollectionItem in section.items {
                    if predicate(item) {
                        return item
                    }
                }
            }
            return nil
        }

        public func indexPath(item: IQCollectionItem) -> IndexPath? {
            var sectionIndex: Int = 0
            for existSection: IQCollectionSection in self.sections {
                var itemIndex: Int = 0
                for existItem: IQCollectionItem in existSection.items {
                    if existItem === item {
                        return IndexPath.init(item: itemIndex, section: sectionIndex)
                    }
                    itemIndex += 1
                }
                sectionIndex += 1
            }
            return nil
        }

        public func indexPath(predicate: (IQCollectionItem) -> Bool) -> IndexPath? {
            var sectionIndex: Int = 0
            for existSection: IQCollectionSection in self.sections {
                var itemIndex: Int = 0
                for existItem: IQCollectionItem in existSection.items {
                    if predicate(existItem) == true {
                        return IndexPath(item: itemIndex, section: sectionIndex)
                    }
                    itemIndex += 1
                }
                sectionIndex += 1
            }
            return nil
        }

        public func dequeue(data: IQCollectionData, kind: String, indexPath: IndexPath) -> IQCollectionDecor? {
            guard let collectionView: UICollectionView = self.collectionView else {
                return nil
            }
            guard let decorClass: IQCollectionDecor.Type = self.decorClass(data: data) else {
                return nil
            }
            return decorClass.dequeue(collectionView: collectionView, kind: kind, indexPath: indexPath) as? IQCollectionDecor
        }

        public func dequeue(item: IQCollectionItem, indexPath: IndexPath) -> IQCollectionCell? {
            guard let collectionView: UICollectionView = self.collectionView else {
                return nil
            }
            guard let cellClass: IQCollectionCell.Type = self.cellClass(item: item) else {
                return nil
            }
            return cellClass.dequeue(collectionView: collectionView, indexPath: indexPath) as? IQCollectionCell
        }

        public func reload() {
            guard let collectionView: UICollectionView = self.collectionView else {
                return
            }
            collectionView.reloadData()
        }

        public func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
            guard let collectionView: UICollectionView = self.collectionView else {
                return
            }
            collectionView.performBatchUpdates(updates, completion: completion)
        }

        public func scroll(item: IQCollectionItem, scroll: UICollectionViewScrollPosition, animated: Bool) {
            guard let collectionView: UICollectionView = self.collectionView else {
                return
            }
            guard let indexPath: IndexPath = self.indexPath(item: item) else {
                return
            }
            collectionView.scrollToItem(at: indexPath, at: scroll, animated: animated)
        }

        public func isSelected(item: IQCollectionItem) -> Bool {
            guard let collectionView: UICollectionView = self.collectionView else {
                return false
            }
            guard let selectedIndexPaths: [IndexPath] = collectionView.indexPathsForSelectedItems else {
                return false
            }
            if let indexPath: IndexPath = self.indexPath(item: item) {
                return selectedIndexPaths.contains(indexPath)
            }
            return false
        }

        public func select(item: IQCollectionItem, scroll: UICollectionViewScrollPosition, animated: Bool) {
            guard let collectionView: UICollectionView = self.collectionView else {
                return
            }
            guard let indexPath: IndexPath = self.indexPath(item: item) else {
                return
            }
            collectionView.selectItem(at: indexPath, animated: animated, scrollPosition: scroll)
        }

        public func deselect(item: IQCollectionItem, animated: Bool) {
            guard let collectionView: UICollectionView = self.collectionView else {
                return
            }
            guard let indexPath: IndexPath = self.indexPath(item: item) else {
                return
            }
            collectionView.deselectItem(at: indexPath, animated: animated)
        }

        public func update(header: IQCollectionData, kind: String) {
            if #available(iOS 9.0, *) {
                guard let collectionView: UICollectionView = self.collectionView else {
                    return
                }
                guard let index: Int = self.index(header: header) else {
                    return
                }
                guard let decor: IQCollectionDecor = collectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: index)) as? IQCollectionDecor else {
                    return
                }
                decor.update(any: header)
            }
        }

        public func update(footer: IQCollectionData, kind: String) {
            if #available(iOS 9.0, *) {
                guard let collectionView: UICollectionView = self.collectionView else {
                    return
                }
                guard let index = self.index(footer: footer) else {
                    return
                }
                guard let decor: IQCollectionDecor = collectionView.supplementaryView(forElementKind: UICollectionElementKindSectionFooter, at: IndexPath(item: 0, section: index)) as? IQCollectionDecor else {
                    return
                }
                decor.update(any: footer)
            }
        }

        public func update(item: IQCollectionItem) {
            guard let collectionView: UICollectionView = self.collectionView else {
                return
            }
            guard let indexPath: IndexPath = self.indexPath(item: item) else {
                return
            }
            guard let cell: IQCollectionCell = collectionView.cellForItem(at: indexPath) as? IQCollectionCell else {
                return
            }
            cell.update(any: item)
        }

    }

    extension QCollectionController: UICollectionViewDataSource {

        public func numberOfSections(
            in collectionView: UICollectionView
        ) -> Int {
            return self.sections.count
        }

        public func collectionView(
            _ collectionView: UICollectionView,
            numberOfItemsInSection index: Int
        ) -> Int {
            let section: IQCollectionSection = self.section(index: index)
            if section.hidden == true {
                return 0
            }
            return section.items.count
        }

        public func collectionView(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
            let item: IQCollectionItem = self.item(indexPath: indexPath)
            return self.dequeue(item: item, indexPath: indexPath) as! UICollectionViewCell
        }

        public func collectionView(
            _ collectionView: UICollectionView,
            viewForSupplementaryElementOfKind kind: String,
            at indexPath: IndexPath
        ) -> UICollectionReusableView {
            var data: IQCollectionData? = nil
            if kind == UICollectionElementKindSectionHeader {
                data = self.header(index: indexPath.section)
            } else if kind == UICollectionElementKindSectionFooter {
                data = self.footer(index: indexPath.section)
            }
            return self.dequeue(data: data!, kind: kind, indexPath: indexPath) as! UICollectionReusableView
        }

        public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
            let section: IQCollectionSection = self.section(index: indexPath.section)
            if section.canMove == false {
                return false;
            }
            let item: IQCollectionItem = section.items[indexPath.item]
            return item.canMove;
        }

    }

    extension QCollectionController: UICollectionViewDelegate {

        public func collectionView(
            _ collectionView: UICollectionView,
            willDisplay cell: UICollectionViewCell,
            forItemAt indexPath: IndexPath
        ) {
            if let collectionCell: IQCollectionCell = cell as? IQCollectionCell {
                let item: IQCollectionItem = self.item(indexPath: indexPath)
                collectionCell.collectionDelegate = self
                collectionCell.set(any: item)
            }
        }

        public func collectionView(
            _ collectionView: UICollectionView,
            willDisplaySupplementaryView view: UICollectionReusableView,
            forElementKind elementKind: String,
            at indexPath: IndexPath
        ) {
            var data: IQCollectionData? = nil
            if elementKind == UICollectionElementKindSectionHeader {
                data = self.header(index: indexPath.section)
            } else if elementKind == UICollectionElementKindSectionFooter {
                data = self.footer(index: indexPath.section)
            }
            if let safeData: IQCollectionData = data {
                if let collectionDecor: IQCollectionDecor = view as? IQCollectionDecor {
                    collectionDecor.collectionDelegate = self
                    collectionDecor.set(any: safeData)
                }
            }
        }

        public func collectionView(
            _ collectionView: UICollectionView,
            shouldHighlightItemAt indexPath: IndexPath
        ) -> Bool {
            let item: IQCollectionItem = self.item(indexPath: indexPath)
            return item.canSelect
        }

        public func collectionView(
            _ collectionView: UICollectionView,
            shouldSelectItemAt indexPath: IndexPath
        ) -> Bool {
            let item: IQCollectionItem = self.item(indexPath: indexPath)
            return item.canSelect
        }

        public func collectionView(
            _ collectionView: UICollectionView,
            shouldDeselectItemAt indexPath: IndexPath
        ) -> Bool {
            let item: IQCollectionItem = self.item(indexPath: indexPath)
            return item.canDeselect
        }

    }

    extension QCollectionController: UICollectionViewDelegateFlowLayout {

        public func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
            let section: IQCollectionSection = self.section(index: indexPath.section)
            let item: IQCollectionItem = self.item(indexPath: indexPath)
            if let cellClass: IQCollectionCell.Type = self.cellClass(item: item) {
                return cellClass.size(any: item, layout: collectionViewLayout, section: section, size: collectionView.frame.size)
            }
            return CGSize.zero
        }

        public func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            insetForSectionAt index: Int
        ) -> UIEdgeInsets {
            let section: IQCollectionSection = self.section(index: index)
            return section.insets
        }

        public func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumLineSpacingForSectionAt index: Int
        ) -> CGFloat {
            let section: IQCollectionSection = self.section(index: index)
            return section.minimumLineSpacing
        }

        public func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumInteritemSpacingForSectionAt index: Int
        ) -> CGFloat {
            let section: IQCollectionSection = self.section(index: index)
            return section.minimumInteritemSpacing
        }

        public func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            referenceSizeForHeaderInSection sectionIndex: Int
        ) -> CGSize {
            let section: IQCollectionSection = self.section(index: sectionIndex)
            if let data: IQCollectionData = section.header {
                if let decorClass: IQCollectionDecor.Type = self.decorClass(data: data) {
                    return decorClass.size(any: data, layout: collectionViewLayout, section: section, size: collectionView.frame.size)
                }
            }
            return CGSize.zero
        }

        public func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            referenceSizeForFooterInSection sectionIndex: Int
        ) -> CGSize {
            let section: IQCollectionSection = self.section(index: sectionIndex)
            if let data: IQCollectionData = section.footer {
                if let decorClass: IQCollectionDecor.Type = self.decorClass(data: data) {
                    return decorClass.size(any: data, layout: collectionViewLayout, section: section, size: collectionView.frame.size)
                }
            }
            return CGSize.zero
        }

    }

#endif

