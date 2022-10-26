//
//  Quickly
//

import UIKit

public protocol IQCollectionControllerObserver : AnyObject {

    func beginScroll(_ controller: IQCollectionController, collectionView: UICollectionView)
    func scroll(_ controller: IQCollectionController, collectionView: UICollectionView)
    func finishScroll(_ controller: IQCollectionController, collectionView: UICollectionView, velocity: CGPoint) -> CGPoint?
    func endScroll(_ controller: IQCollectionController, collectionView: UICollectionView)
    
    func beginZoom(_ controller: IQCollectionController, collectionView: UICollectionView)
    func zoom(_ controller: IQCollectionController, collectionView: UICollectionView)
    func endZoom(_ controller: IQCollectionController, collectionView: UICollectionView)
    
    func update(_ controller: IQCollectionController)

}

public protocol IQCollectionController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: (UICollectionView & IQContainerSpec)? { set get }
    var sections: [IQCollectionSection] { set get }
    var items: [IQCollectionItem] { get }
    var selectedItems: [IQCollectionItem] { set get }
    var canMove: Bool { get }
    var isBatchUpdating: Bool { get }

    func configure()
    
    func rebuild()

    func add(observer: IQCollectionControllerObserver, priority: UInt)
    func remove(observer: IQCollectionControllerObserver)

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

    func dequeue(data: IQCollectionData, kind: String, indexPath: IndexPath) -> (UICollectionReusableView & IQCollectionDecor)?
    func dequeue(item: IQCollectionItem, indexPath: IndexPath) -> (UICollectionViewCell & IQCollectionCell)?

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

    func scroll(item: IQCollectionItem, scroll: UICollectionView.ScrollPosition, animated: Bool)

    func isSelected(item: IQCollectionItem) -> Bool
    func select(item: IQCollectionItem, scroll: UICollectionView.ScrollPosition, animated: Bool)
    func deselect(item: IQCollectionItem, animated: Bool)
    func deselectAll(animated: Bool)

    func update(header: IQCollectionData, animated: Bool)
    func update(footer: IQCollectionData, animated: Bool)
    func update(item: IQCollectionItem, animated: Bool)

}

public extension IQCollectionController {

    func prependSection(_ section: IQCollectionSection) {
        self.insertSection([ section ], index: self.sections.startIndex)
    }

    func prependSection(_ sections: [IQCollectionSection]) {
        self.insertSection(sections, index: self.sections.startIndex)
    }

    func appendSection(_ section: IQCollectionSection) {
        self.insertSection([ section ], index: self.sections.endIndex)
    }

    func appendSection(_ sections: [IQCollectionSection]) {
        self.insertSection(sections, index: self.sections.endIndex)
    }

    func insertSection(_ section: IQCollectionSection, index: Int) {
        self.insertSection([ section ], index: index)
    }

    func deleteSection(_ section: IQCollectionSection) {
        self.deleteSection([ section ])
    }

    func reloadSection(_ section: IQCollectionSection) {
        self.reloadSection([ section ])
    }

}
