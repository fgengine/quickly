//
//  Quickly
//

#if os(iOS)

    public protocol IQCollectionDecorDelegate : class {
    }

    public protocol IQCollectionDecor : IQCollectionReuse {

        typealias DequeueType = UICollectionReusableView & IQCollectionDecor

        var collectionDelegate: IQCollectionDecorDelegate? { set get }

        static func register(collectionView: UICollectionView, kind: String)

        static func dequeue(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> DequeueType?

        func configure()

        func set(any: Any)
        func update(any: Any)

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

        func set(data: DataType)
        func update(data: DataType)

    }

    extension IQTypedCollectionDecor {

        public static func using(any: Any) -> Bool {
            return any is DataType
        }

        public static func usingLevel(any: AnyClass) -> UInt? {
            var selfclass: AnyClass = any
            var level: UInt = 0
            while selfclass !== DataType.self {
                guard let superclass = selfclass.superclass() else { return nil }
                selfclass = superclass
                level += 1
            }
            return level
        }

        public static func size(any: Any, layout: UICollectionViewLayout, section: IQCollectionSection, size: CGSize) -> CGSize {
            return self.size(data: any as! DataType, layout: layout, section: section, size: size)
        }

        public func set(any: Any) {
            self.set(data: any as! DataType)
        }

        public func update(any: Any) {
            self.update(data: any as! DataType)
        }

    }

#endif
