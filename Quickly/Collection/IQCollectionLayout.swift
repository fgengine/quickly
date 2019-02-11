//
//  Quickly
//

public protocol IQCollectionLayoutObserver : class {

    func update(_ layout: IQCollectionLayout, contentSize: CGSize)

}

public protocol IQCollectionLayout : class {

    func addObserver(_ observer: IQCollectionLayoutObserver, priority: UInt)
    func removeObserver(_ observer: IQCollectionLayoutObserver)

}

public typealias QCollectionLayoutType = IQCollectionLayout & UICollectionViewLayout
