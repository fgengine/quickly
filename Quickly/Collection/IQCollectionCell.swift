//
//  Quickly
//

import UIKit

public protocol CollectionCellDelegate: class {
}

public protocol IQCollectionCell: IQCollectionReuse {

    weak var collectionDelegate: CollectionCellDelegate? { set get }

    static func register(collectionView: UICollectionView)

    static func dequeue(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell?

    func configure()

    func set(any: Any)
    func update(any: Any)
    
}

extension IQCollectionCell where Self: UICollectionViewCell {

    public static func register(collectionView: UICollectionView) {
        if let nib: UINib = self.currentNib() {
            collectionView.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier())
        } else {
            collectionView.register(self.classForCoder(), forCellWithReuseIdentifier: self.reuseIdentifier())
        }
    }

    public static func dequeue(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell? {
        return collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier(), for: indexPath)
    }
    
}

public protocol IQTypedCollectionCell: IQCollectionCell {

    associatedtype ItemType: IQCollectionItem

    var item: ItemType? { get }

    static func size(item: ItemType, layout: UICollectionViewLayout, section: IQCollectionSection, size: CGSize) -> CGSize

    func set(item: ItemType)
    func update(item: ItemType)

}

extension IQTypedCollectionCell {

    public static func using(any: Any) -> Bool {
        return any is ItemType
    }

    public static func size(any: Any, layout: UICollectionViewLayout, section: IQCollectionSection, size: CGSize) -> CGSize {
        return self.size(item: any as! ItemType, layout: layout, section: section, size: size)
    }

    public func set(any: Any) {
        self.set(item: any as! ItemType)
    }

    public func update(any: Any) {
        self.update(item: any as! ItemType)
    }
    
}
