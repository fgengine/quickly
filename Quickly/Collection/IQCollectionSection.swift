//
//  Quickly
//

import UIKit

public protocol IQCollectionSection : AnyObject {

    var controller: IQCollectionController? { get }
    var index: Int? { get }
    var insets: UIEdgeInsets? { get }
    var minimumLineSpacing: CGFloat? { get }
    var minimumInteritemSpacing: CGFloat? { get }

    var canMove: Bool { get }
    var hidden: Bool { get }

    var header: IQCollectionData? { set get }
    var footer: IQCollectionData? { set get }
    var items: [IQCollectionItem] { get }

    func bind(_ controller: IQCollectionController, _ index: Int)
    func unbind()
    
    func setItems(_ items: [IQCollectionItem])
    
    func prependItem(_ item: IQCollectionItem)
    func prependItem(_ items: [IQCollectionItem])
    func appendItem(_ item: IQCollectionItem)
    func appendItem(_ items: [IQCollectionItem])
    func insertItem(_ item: IQCollectionItem, index: Int)
    func insertItem(_ items: [IQCollectionItem], index: Int)
    func deleteItem(_ item: IQCollectionItem)
    func deleteItem(_ items: [IQCollectionItem])
    func replaceItem(_ item: IQCollectionItem, index: Int)
    func reloadItem(_ item: IQCollectionItem)
    func reloadItem(_ items: [IQCollectionItem])

    func moveItem(_ fromItem: IQCollectionItem, toIndex: Int) -> Bool
    func moveItem(_ fromIndex: Int, toIndex: Int)

}

public extension IQCollectionSection {

    func prependItem(_ item: IQCollectionItem) {
        self.insertItem([ item ], index: self.items.startIndex)
    }

    func prependItem(_ items: [IQCollectionItem]) {
        self.insertItem(items, index: self.items.startIndex)
    }

    func appendItem(_ item: IQCollectionItem) {
        self.insertItem([ item ], index: self.items.endIndex)
    }

    func appendItem(_ items: [IQCollectionItem]) {
        self.insertItem(items, index: self.items.endIndex)
    }

    func insertItem(_ item: IQCollectionItem, index: Int) {
        self.insertItem([ item ], index: index)
    }

    func deleteItem(_ item: IQCollectionItem) {
        self.deleteItem([ item ])
    }

    func reloadItem(_ item: IQCollectionItem) {
        self.reloadItem([ item ])
    }

    func moveItem(_ fromItem: IQCollectionItem, toIndex: Int) -> Bool {
        guard let fromIndex = self.items.firstIndex(where: { (existItem: IQCollectionItem) -> Bool in
            return (existItem === fromItem)
        }) else {
            return false
        }
        self.moveItem(fromIndex, toIndex: toIndex)
        return true
    }

}
