//
//  Quickly
//

import UIKit

public protocol IQCollectionDecorDelegate: class {
}

public protocol IQCollectionDecor: IQCollectionReuse {

    weak var collectionDelegate: IQCollectionDecorDelegate? { set get }

    static func register(collectionView: UICollectionView, kind: String)

    static func dequeue(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView?

    func configure()

    func set(any: Any)
    func update(any: Any)
    
}

extension IQCollectionDecor where Self: UIView {

    public static func register(collectionView: UICollectionView, kind: String) {
        if let nib: UINib = self.currentNib() {
            collectionView.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: self.reuseIdentifier())
        } else {
            collectionView.register(self.classForCoder(), forSupplementaryViewOfKind: kind, withReuseIdentifier: self.reuseIdentifier())
        }
    }

    public static func dequeue(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.reuseIdentifier(), for: indexPath)
    }

}

public protocol IQTypedCollectionDecor: IQCollectionDecor {

    associatedtype DataType: IQCollectionData

    static func size(data: DataType, size: CGSize) -> CGSize

    func set(data: DataType)
    func update(data: DataType)

}

extension IQTypedCollectionDecor {

    public static func using(any: Any) -> Bool {
        return any is DataType
    }

    public static func size(any: Any, size: CGSize) -> CGSize {
        return self.size(data: any as! DataType, size: size)
    }

    public func set(any: Any) {
        self.set(data: any as! DataType)
    }

    public func update(any: Any) {
        self.update(data: any as! DataType)
    }
    
}
