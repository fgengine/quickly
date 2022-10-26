//
//  Quickly
//

import UIKit

public protocol CollectionCellDelegate : AnyObject {
}

public protocol IQCollectionCell : IQCollectionReuse {

    var collectionDelegate: CollectionCellDelegate? { set get }

    static func register(collectionView: UICollectionView)

    static func dequeue(collectionView: UICollectionView, indexPath: IndexPath) -> (UICollectionViewCell & IQCollectionCell)?

    func configure()

    func set(any: Any, spec: IQContainerSpec, animated: Bool)
    
    func beginDisplay()
    func endDisplay()

}

extension IQCollectionCell where Self : UICollectionViewCell {

    public static func register(collectionView: UICollectionView) {
        if let nib = self.currentNib() {
            collectionView.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier())
        } else {
            collectionView.register(self.classForCoder(), forCellWithReuseIdentifier: self.reuseIdentifier())
        }
    }

    public static func dequeue(collectionView: UICollectionView, indexPath: IndexPath) -> (UICollectionViewCell & IQCollectionCell)? {
        return collectionView.dequeueReusableCell(
            withReuseIdentifier: self.reuseIdentifier(),
            for: indexPath
        ) as? (UICollectionViewCell & IQCollectionCell)
    }

}

public protocol IQTypedCollectionCell : IQCollectionCell {

    associatedtype Item: IQCollectionItem

    var item: Item? { get }

    static func size(item: Item, layout: UICollectionViewLayout, section: IQCollectionSection, spec: IQContainerSpec) -> CGSize

    func set(item: Item, spec: IQContainerSpec, animated: Bool)

}

extension IQTypedCollectionCell {

    public static func using(any: Any) -> Bool {
        return any is Item
    }

    public static func usingLevel(any: AnyClass) -> UInt? {
        return QInheritanceLevel(any, Item.self)
    }

    public static func size(any: Any, layout: UICollectionViewLayout, section: IQCollectionSection, spec: IQContainerSpec) -> CGSize {
        return self.size(item: any as! Item, layout: layout, section: section, spec: spec)
    }

    public func set(any: Any, spec: IQContainerSpec, animated: Bool) {
        self.set(item: any as! Item, spec: spec, animated: animated)
    }

}
