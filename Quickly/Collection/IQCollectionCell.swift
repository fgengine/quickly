//
//  Quickly
//

public protocol CollectionCellDelegate : class {
}

public protocol IQCollectionCell : IQCollectionReuse {

    typealias Dequeue = UICollectionViewCell & IQCollectionCell

    var collectionDelegate: CollectionCellDelegate? { set get }

    static func register(collectionView: UICollectionView)

    static func dequeue(collectionView: UICollectionView, indexPath: IndexPath) -> Dequeue?

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

    public static func dequeue(collectionView: UICollectionView, indexPath: IndexPath) -> Dequeue? {
        return collectionView.dequeueReusableCell(
            withReuseIdentifier: self.reuseIdentifier(),
            for: indexPath
        ) as? Dequeue
    }

}

public protocol IQTypedCollectionCell : IQCollectionCell {

    associatedtype Item: IQCollectionItem

    var item: Item? { get }

    static func size(item: Item, layout: UICollectionViewLayout, section: IQCollectionSection, size: CGSize) -> CGSize

    func set(item: Item, animated: Bool)

}

extension IQTypedCollectionCell {

    public static func using(any: Any) -> Bool {
        return any is Item
    }

    public static func usingLevel(any: AnyClass) -> UInt? {
        return inheritanceLevel(any, Item.self)
    }

    public static func size(any: Any, layout: UICollectionViewLayout, section: IQCollectionSection, size: CGSize) -> CGSize {
        return self.size(item: any as! Item, layout: layout, section: section, size: size)
    }

    public func set(any: Any, animated: Bool) {
        self.set(item: any as! Item, animated: animated)
    }

}
