//
//  Quickly
//

import UIKit

public protocol IQCollectionDecorDelegate : AnyObject {
}

public protocol IQCollectionDecor : IQCollectionReuse {

    typealias Dequeue = UICollectionReusableView & IQCollectionDecor

    var collectionDelegate: IQCollectionDecorDelegate? { set get }

    static func register(collectionView: UICollectionView, kind: String)

    static func dequeue(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> Dequeue?

    func configure()

    func set(any: Any, spec: IQContainerSpec, animated: Bool)

}

extension IQCollectionDecor where Self : UICollectionReusableView {

    public static func register(collectionView: UICollectionView, kind: String) {
        if let nib = self.currentNib() {
            collectionView.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: self.reuseIdentifier())
        } else {
            collectionView.register(self.classForCoder(), forSupplementaryViewOfKind: kind, withReuseIdentifier: self.reuseIdentifier())
        }
    }

    public static func dequeue(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> Dequeue? {
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: self.reuseIdentifier(),
            for: indexPath
        ) as? Dequeue
    }

}

public protocol IQTypedCollectionDecor : IQCollectionDecor {

    associatedtype DataType: IQCollectionData

    static func size(data: DataType, layout: UICollectionViewLayout, section: IQCollectionSection, spec: IQContainerSpec) -> CGSize

    func set(data: DataType, spec: IQContainerSpec, animated: Bool)

}

extension IQTypedCollectionDecor {

    public static func using(any: Any) -> Bool {
        return any is DataType
    }

    public static func usingLevel(any: AnyClass) -> UInt? {
        return QInheritanceLevel(any, DataType.self)
    }

    public static func size(any: Any, layout: UICollectionViewLayout, section: IQCollectionSection, spec: IQContainerSpec) -> CGSize {
        return self.size(data: any as! DataType, layout: layout, section: section, spec: spec)
    }

    public func set(any: Any, spec: IQContainerSpec, animated: Bool) {
        self.set(data: any as! DataType, spec: spec, animated: animated)
    }

}
