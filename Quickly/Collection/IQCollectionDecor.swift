//
//  Quickly
//

public protocol IQCollectionDecorDelegate : class {
}

public protocol IQCollectionDecor : IQCollectionReuse {

    typealias DequeueType = UICollectionReusableView & IQCollectionDecor

    var collectionDelegate: IQCollectionDecorDelegate? { set get }

    static func register(collectionView: UICollectionView, kind: String)

    static func dequeue(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> DequeueType?

    func configure()

    func set(any: Any, animated: Bool)

}

extension IQCollectionDecor where Self : UICollectionReusableView {

    public static func register(collectionView: UICollectionView, kind: String) {
        if let nib = self.currentNib() {
            collectionView.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: self.reuseIdentifier())
        } else {
            collectionView.register(self.classForCoder(), forSupplementaryViewOfKind: kind, withReuseIdentifier: self.reuseIdentifier())
        }
    }

    public static func dequeue(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> DequeueType? {
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: self.reuseIdentifier(),
            for: indexPath
        ) as? DequeueType
    }

}

public protocol IQTypedCollectionDecor : IQCollectionDecor {

    associatedtype DataType: IQCollectionData

    static func size(data: DataType, layout: UICollectionViewLayout, section: IQCollectionSection, size: CGSize) -> CGSize

    func set(data: DataType, animated: Bool)

}

extension IQTypedCollectionDecor {

    public static func using(any: Any) -> Bool {
        return any is DataType
    }

    public static func usingLevel(any: AnyClass) -> UInt? {
        return inheritanceLevel(any, DataType.self)
    }

    public static func size(any: Any, layout: UICollectionViewLayout, section: IQCollectionSection, size: CGSize) -> CGSize {
        return self.size(data: any as! DataType, layout: layout, section: section, size: size)
    }

    public func set(any: Any, animated: Bool) {
        self.set(data: any as! DataType, animated: animated)
    }

}
