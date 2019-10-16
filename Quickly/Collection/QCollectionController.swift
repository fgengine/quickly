//
//  Quickly
//

open class QCollectionController : NSObject, IQCollectionController, CollectionCellDelegate, IQCollectionDecorDelegate {
    
    public typealias CollectionView = IQCollectionController.CollectionView
    public typealias Decor = IQCollectionController.Decor
    public typealias Cell = IQCollectionController.Cell

    public weak var collectionView: CollectionView? = nil {
        didSet { if self.collectionView != nil { self.configure() } }
    }
    public var sections: [IQCollectionSection] = [] {
        willSet { self._unbindSections() }
        didSet { self._bindSections() }
    }
    public var items: [IQCollectionItem] {
        get {
            return self.sections.flatMap({ (section: IQCollectionSection) -> [IQCollectionItem] in
                return section.items
            })
        }
    }
    public var selectedItems: [IQCollectionItem] {
        set(value) {
            guard
                let collectionView = self.collectionView
                else { return }
            if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
                for indexPath in selectedIndexPaths {
                    collectionView.deselectItem(at: indexPath, animated: false)
                }
            }
            for item in value {
                collectionView.selectItem(at: item.indexPath, animated: false, scrollPosition: [])
            }
        }
        get {
            guard
                let collectionView = self.collectionView,
                let selectedIndexPaths = collectionView.indexPathsForSelectedItems
                else { return [] }
            return selectedIndexPaths.compactMap({ (indexPath: IndexPath) -> IQCollectionItem? in
                return self.sections[indexPath.section].items[indexPath.item]
            })
        }
    }
    public var canMove: Bool = true
    public private(set) var isBatchUpdating: Bool = false
    public private(set) var decors: [IQCollectionDecor.Type]
    public private(set) var cells: [IQCollectionCell.Type]
    
    private var _aliasDecors: [QMetatype : IQCollectionDecor.Type]
    private var _aliasCells: [QMetatype : IQCollectionCell.Type]
    private var _observer: QObserver< IQCollectionControllerObserver >

    public init(
        cells: [IQCollectionCell.Type]
    ) {
        self.decors = []
        self._aliasDecors = [:]
        self.cells = cells
        self._aliasCells = [:]
        self._observer = QObserver< IQCollectionControllerObserver >()
        super.init()
    }

    public init(
        decors: [IQCollectionDecor.Type],
        cells: [IQCollectionCell.Type]
    ) {
        self.decors = decors
        self._aliasDecors = [:]
        self.cells = cells
        self._aliasCells = [:]
        self._observer = QObserver< IQCollectionControllerObserver >()
        super.init()
    }

    open func configure() {
        if let collectionView = self.collectionView {
            for type in self.decors {
                type.register(collectionView: collectionView, kind: UICollectionView.elementKindSectionHeader)
                type.register(collectionView: collectionView, kind: UICollectionView.elementKindSectionFooter)
            }
            for type in self.cells {
                type.register(collectionView: collectionView)
            }
        }
        self.reload()
    }

    open func add(observer: IQCollectionControllerObserver, priority: UInt) {
        self._observer.add(observer, priority: priority)
    }

    open func remove(observer: IQCollectionControllerObserver) {
        self._observer.remove(observer)
    }

    open func section(index: Int) -> IQCollectionSection {
        return self.sections[index]
    }

    open func index(section: IQCollectionSection) -> Int? {
        return self.sections.firstIndex { (existSection: IQCollectionSection) -> Bool in
            return existSection === section
        }
    }

    open func header(index: Int) -> IQCollectionData? {
        return self.sections[index].header
    }

    open func index(header: IQCollectionData) -> Int? {
        return self.sections.firstIndex(where: { (existSection: IQCollectionSection) -> Bool in
            return existSection.header === header
        })
    }

    open func footer(index: Int) -> IQCollectionData? {
        return self.sections[index].footer
    }

    open func index(footer: IQCollectionData) -> Int? {
        return self.sections.firstIndex(where: { (existSection: IQCollectionSection) -> Bool in
            return existSection.footer === footer
        })
    }

    open func item(indexPath: IndexPath) -> IQCollectionItem {
        return self.sections[indexPath.section].items[indexPath.item]
    }

    open func item(predicate: (IQCollectionItem) -> Bool) -> IQCollectionItem? {
        for section in self.sections {
            for item in section.items {
                if predicate(item) {
                    return item
                }
            }
        }
        return nil
    }

    open func indexPath(item: IQCollectionItem) -> IndexPath? {
        return item.indexPath
    }

    open func indexPath(predicate: (IQCollectionItem) -> Bool) -> IndexPath? {
        for existSection in self.sections {
            for existItem in existSection.items {
                if predicate(existItem) == true {
                    return existItem.indexPath
                }
            }
        }
        return nil
    }

    open func dequeue(data: IQCollectionData, kind: String, indexPath: IndexPath) -> Decor? {
        guard
            let collectionView = self.collectionView,
            let decorClass = self._decorClass(data: data),
            let decorView = decorClass.dequeue(collectionView: collectionView, kind: kind, indexPath: indexPath)
            else { return nil }
        decorView.collectionDelegate = self
        return decorView
    }

    open func dequeue(item: IQCollectionItem, indexPath: IndexPath) -> Cell? {
        guard
            let collectionView = self.collectionView,
            let cellClass = self._cellClass(item: item),
            let cellView = cellClass.dequeue(collectionView: collectionView, indexPath: indexPath)
            else { return nil }
        cellView.collectionDelegate = self
        return cellView
    }

    open func reload() {
        guard let collectionView = self.collectionView else { return }
        collectionView.reloadData()
        self._notifyUpdate()
    }

    open func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        #if DEBUG
            assert(self.isBatchUpdating == false, "Recurcive calling IQCollectionController.performBatchUpdates()")
        #endif
        guard let collectionView = self.collectionView else { return }
        self.isBatchUpdating = true
        collectionView.performBatchUpdates(updates, completion: { [weak self] (finish: Bool) in
            if let self = self {
                self.isBatchUpdating = false
                self._notifyUpdate()
            }
            completion?(finish)
        })
    }

    open func insertSection(_ sections: [IQCollectionSection], index: Int) {
        self.sections.insert(contentsOf: sections, at: index)
        self._bindSections(from: index, to: self.sections.endIndex)
        var indexSet = IndexSet()
        for section in self.sections {
            if let sectionIndex = section.index {
                indexSet.insert(sectionIndex)
            }
        }
        if indexSet.count > 0 {
            if let collectionView = self.collectionView {
                collectionView.insertSections(indexSet)
            }
        }
    }

    open func deleteSection(_ sections: [IQCollectionSection]) {
        var indexSet = IndexSet()
        for section in sections {
            if let index = self.sections.firstIndex(where: { return ($0 === section) }) {
                indexSet.insert(index)
            }
        }
        if indexSet.count > 0 {
            for index in indexSet.reversed() {
                let section = self.sections[index]
                self.sections.remove(at: index)
                section.unbind()
            }
            self._bindSections(from: indexSet.first!, to: self.sections.endIndex)
            if let collectionView = self.collectionView {
                collectionView.deleteSections(indexSet)
            }
        }
    }

    open func reloadSection(_ sections: [IQCollectionSection]) {
        var indexSet = IndexSet()
        for section in sections {
            if let index = self.sections.firstIndex(where: { return ($0 === section) }) {
                indexSet.insert(index)
            }
        }
        if indexSet.count > 0 {
            if let collectionView = self.collectionView {
                collectionView.reloadSections(indexSet)
            }
        }
    }

    open func scroll(item: IQCollectionItem, scroll: UICollectionView.ScrollPosition, animated: Bool) {
        guard
            let collectionView = self.collectionView,
            let indexPath = self.indexPath(item: item)
            else { return }
        collectionView.scrollToItem(at: indexPath, at: scroll, animated: animated)
    }

    open func isSelected(item: IQCollectionItem) -> Bool {
        guard
            let collectionView = self.collectionView,
            let selectedIndexPaths = collectionView.indexPathsForSelectedItems,
            let indexPath = self.indexPath(item: item)
            else { return false }
        return selectedIndexPaths.contains(indexPath)
    }

    open func select(item: IQCollectionItem, scroll: UICollectionView.ScrollPosition, animated: Bool) {
        guard
            let collectionView = self.collectionView,
            let indexPath = self.indexPath(item: item)
            else { return }
        collectionView.selectItem(at: indexPath, animated: animated, scrollPosition: scroll)
    }

    open func deselect(item: IQCollectionItem, animated: Bool) {
        guard
            let collectionView = self.collectionView,
            let indexPath = self.indexPath(item: item)
            else { return }
        collectionView.deselectItem(at: indexPath, animated: animated)
    }

    open func update(header: IQCollectionData, animated: Bool) {
        if #available(iOS 9.0, *) {
            guard
                let collectionView = self.collectionView,
                let index = self.index(header: header),
                let decor = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: index)) as? IQCollectionDecor
                else { return }
            decor.set(any: header, spec: collectionView, animated: animated)
            if self.isBatchUpdating == false {
                self._notifyUpdate()
            }
        }
    }

    open func update(footer: IQCollectionData, animated: Bool) {
        if #available(iOS 9.0, *) {
            guard
                let collectionView = self.collectionView,
                let index = self.index(footer: footer),
                let decor = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: index)) as? IQCollectionDecor
                else { return }
            decor.set(any: footer, spec: collectionView, animated: animated)
            if self.isBatchUpdating == false {
                self._notifyUpdate()
            }
        }
    }

    open func update(item: IQCollectionItem, animated: Bool) {
        guard
            let collectionView = self.collectionView,
            let indexPath = self.indexPath(item: item),
            let cell = collectionView.cellForItem(at: indexPath) as? IQCollectionCell
            else { return }
        cell.set(any: item, spec: collectionView, animated: animated)
        if self.isBatchUpdating == false {
            self._notifyUpdate()
        }
    }

}

// MARK: Private

private extension QCollectionController {

    func _bindSections() {
        var sectionIndex: Int = 0
        for section in self.sections {
            section.bind(self, sectionIndex)
            sectionIndex += 1
        }
    }

    func _bindSections(from: Int, to: Int) {
        for index in from..<to {
            self.sections[index].bind(self, index)
        }
    }

    func _unbindSections() {
        for section in self.sections {
            section.unbind()
        }
    }

    func _notifyUpdate() {
        self._observer.notify({ $0.update(self) })
    }
    
    func _decorClass(data: IQCollectionData) -> IQCollectionDecor.Type? {
        let dataMetatype = QMetatype(data)
        if let metatype = self._aliasDecors.first(where: { return $0.key == dataMetatype }) {
            return metatype.value
        }
        let usings = self.decors.filter({ return $0.using(any: data) })
        guard usings.count > 0 else { return nil }
        if usings.count > 1 {
            let typeOfData = type(of: data)
            let levels = usings.compactMap({ (type) -> (IQCollectionDecor.Type, UInt)? in
                guard let level = type.usingLevel(any: typeOfData) else { return nil }
                return (type, level)
            })
            let sorted = levels.sorted(by: { return $0.1 > $1.1 })
            let decorType = sorted.first!.0
            self._aliasDecors[dataMetatype] = decorType
            return decorType
        } else {
            let decorType = usings.first!
            self._aliasDecors[dataMetatype] = decorType
            return decorType
        }
    }
    
    func _cellClass(item: IQCollectionItem) -> IQCollectionCell.Type? {
        let rowMetatype = QMetatype(item)
        if let metatype = self._aliasCells.first(where: { return $0.key == rowMetatype }) {
            return metatype.value
        }
        let usings = self.cells.filter({ return $0.using(any: item) })
        guard usings.count > 0 else { return nil }
        if usings.count > 1 {
            let typeOfData = type(of: item)
            let levels = usings.compactMap({ (type) -> (IQCollectionCell.Type, UInt)? in
                guard let level = type.usingLevel(any: typeOfData) else { return nil }
                return (type, level)
            })
            let sorted = levels.sorted(by: { return $0.1 > $1.1 })
            let cellType = sorted.first!.0
            self._aliasCells[rowMetatype] = cellType
            return cellType
        } else {
            let cellType = usings.first!
            self._aliasCells[rowMetatype] = cellType
            return cellType
        }
    }

}

// MARK: UIScrollViewDelegate

extension QCollectionController : UIScrollViewDelegate {

    @objc
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let collectionView = self.collectionView!
        self._observer.notify({ $0.beginScroll(self, collectionView: collectionView) })
    }
    
    @objc
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionView = self.collectionView!
        self._observer.notify({ $0.scroll(self, collectionView: collectionView) })
    }
    
    @objc
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer< CGPoint >) {
        let collectionView = self.collectionView!
        var targetContentOffsets: [CGPoint] = []
        self._observer.notify({
            if let contentOffset = $0.finishScroll(self, collectionView: collectionView, velocity: velocity) {
                targetContentOffsets.append(contentOffset)
            }
        })
        if targetContentOffsets.count > 0 {
            var avgTargetContentOffset = targetContentOffsets.first!
            if targetContentOffsets.count > 1 {
                for nextTargetContentOffset in targetContentOffsets {
                    avgTargetContentOffset = CGPoint(
                        x: (avgTargetContentOffset.x + nextTargetContentOffset.x) / 2,
                        y: (avgTargetContentOffset.y + nextTargetContentOffset.y) / 2
                    )
                }
            }
            targetContentOffset.pointee = avgTargetContentOffset
        }
    }
    
    @objc
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            let collectionView = self.collectionView!
            self._observer.notify({ $0.endScroll(self, collectionView: collectionView) })
        }
    }
    
    @objc
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let collectionView = self.collectionView!
        self._observer.notify({ $0.endScroll(self, collectionView: collectionView) })
    }
    
    @objc
    open func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        let collectionView = self.collectionView!
        self._observer.notify({ $0.beginZoom(self, collectionView: collectionView) })
    }

    @objc
    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let collectionView = self.collectionView!
        self._observer.notify({ $0.zoom(self, collectionView: collectionView) })
    }
    
    @objc
    open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let collectionView = self.collectionView!
        self._observer.notify({ $0.endZoom(self, collectionView: collectionView) })
    }

}

// MARK: UICollectionViewDataSource

extension QCollectionController : UICollectionViewDataSource {
    
    @objc
    open func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        return self.sections.count
    }
    
    @objc
    open func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection index: Int
    ) -> Int {
        let section = self.section(index: index)
        if section.hidden == true {
            return 0
        }
        return section.items.count
    }
    
    @objc
    open func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let item = self.item(indexPath: indexPath)
        return self.dequeue(item: item, indexPath: indexPath).unsafelyUnwrapped
    }
    
    @objc
    open func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        var data: IQCollectionData? = nil
        if kind == UICollectionView.elementKindSectionHeader {
            data = self.header(index: indexPath.section)
        } else if kind == UICollectionView.elementKindSectionFooter {
            data = self.footer(index: indexPath.section)
        }
        return self.dequeue(data: data!, kind: kind, indexPath: indexPath).unsafelyUnwrapped
    }
    
    @objc
    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        let section = self.section(index: indexPath.section)
        if section.canMove == false {
            return false;
        }
        let item = section.items[indexPath.item]
        return item.canMove;
    }

}

// MARK: UICollectionViewDelegate

extension QCollectionController : UICollectionViewDelegate {
    
    @objc
    open func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if let collectionCell = cell as? IQCollectionCell {
            let item = self.item(indexPath: indexPath)
            collectionCell.set(any: item, spec: collectionView as! IQContainerSpec, animated: false)
        }
    }
    
    @objc
    open func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        var data: IQCollectionData? = nil
        if elementKind == UICollectionView.elementKindSectionHeader {
            data = self.header(index: indexPath.section)
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            data = self.footer(index: indexPath.section)
        }
        if let safeData = data {
            if let collectionDecor = view as? IQCollectionDecor {
                collectionDecor.set(any: safeData, spec: collectionView as! IQContainerSpec, animated: false)
            }
        }
    }
    
    @objc
    open func collectionView(
        _ collectionView: UICollectionView,
        shouldHighlightItemAt indexPath: IndexPath
    ) -> Bool {
        let item = self.item(indexPath: indexPath)
        return item.canSelect
    }
    
    @objc
    open func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        let item = self.item(indexPath: indexPath)
        return item.canSelect
    }
    
    @objc
    open func collectionView(
        _ collectionView: UICollectionView,
        shouldDeselectItemAt indexPath: IndexPath
    ) -> Bool {
        let item = self.item(indexPath: indexPath)
        return item.canDeselect
    }

}

// MARK: UICollectionViewDelegateFlowLayout

extension QCollectionController : UICollectionViewDelegateFlowLayout {
    
    @objc
    open func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let section = self.section(index: indexPath.section)
        let item = self.item(indexPath: indexPath)
        if let cellClass = self._cellClass(item: item) {
            return cellClass.size(any: item, layout: collectionViewLayout, section: section, spec: collectionView as! IQContainerSpec)
        }
        return CGSize.zero
    }
    
    @objc
    open func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt index: Int
    ) -> UIEdgeInsets {
        let section = self.section(index: index)
        return section.insets
    }
    
    @objc
    open func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt index: Int
    ) -> CGFloat {
        let section = self.section(index: index)
        return section.minimumLineSpacing
    }
    
    @objc
    open func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt index: Int
    ) -> CGFloat {
        let section = self.section(index: index)
        return section.minimumInteritemSpacing
    }
    
    @objc
    open func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection sectionIndex: Int
    ) -> CGSize {
        let section = self.section(index: sectionIndex)
        if let data = section.header {
            if let decorClass = self._decorClass(data: data) {
                return decorClass.size(any: data, layout: collectionViewLayout, section: section, spec: collectionView as! IQContainerSpec)
            }
        }
        return CGSize.zero
    }
    
    @objc
    open func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection sectionIndex: Int
    ) -> CGSize {
        let section = self.section(index: sectionIndex)
        if let data = section.footer {
            if let decorClass = self._decorClass(data: data) {
                return decorClass.size(any: data, layout: collectionViewLayout, section: section, spec: collectionView as! IQContainerSpec)
            }
        }
        return CGSize.zero
    }

}
