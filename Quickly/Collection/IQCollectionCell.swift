//
//  Quickly
//

public protocol CollectionCellDelegate : class {
}

public protocol IQCollectionCell : IQCollectionReuse {

    typealias DequeueType = UICollectionViewCell & IQCollectionCell

    var collectionDelegate: CollectionCellDelegate? { set get }

    static func register(collectionView: UICollectionView)

    static func dequeue(collectionView: UICollectionView, indexPath: IndexPath) -> DequeueType?

    func configure()

    func set(any: Any, animated: Bool)

}

extension IQCollectionCell where Self : UICollectionViewCell {

    public static func register(collectionView: UICollectionView) {
        if let nib = self.currentNib() {
            collectionView.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier())
        } else {
            collectionView.register(self.classForCoder(), forCellWithReuseIdentifier: self.reuseIdentifier())
        }
    }

    public static func dequeue(collectionView: UICollectionView, indexPath: IndexPath) -> DequeueType? {
        return collectionView.dequeueReusableCell(
            withReuseIdentifier: self.reuseIdentifier(),
            for: indexPath
        ) as? DequeueType
    }

}

public protocol IQTypedCollectionCell : IQCollectionCell {

    associatedtype ItemType: IQCollectionItem

    var item: ItemType? { get }

    static func size(item: ItemType, layout: UICollectionViewLayout, section: IQCollectionSection, size: CGSize) -> CGSize

    func set(item: ItemType, animated: Bool)

}

extension IQTypedCollectionCell {

    public static func using(any: Any) -> Bool {
        return any is ItemType
    }

    public static func usingLevel(any: AnyClass) -> UInt? {
        return inheritanceLevel(any, ItemType.self)
    }

    public static func size(any: Any, layout: UICollectionViewLayout, section: IQCollectionSection, size: CGSize) -> CGSize {
        return self.size(item: any as! ItemType, layout: layout, section: section, size: size)
    }

    public func set(any: Any, animated: Bool) {
        self.set(item: any as! ItemType, animated: animated)
    }

}
