//
//  Quickly
//

#if os(iOS)

    public protocol IQCollectionLayoutObserver : class {

        func update(_ layout: IQCollectionLayout, contentSize: CGSize)

    }

    public protocol IQCollectionLayout : class {

        func addObserver(_ observer: IQCollectionLayoutObserver)
        func removeObserver(_ observer: IQCollectionLayoutObserver)


    }

#endif

