//
//  Quickly
//

#if os(iOS)

    public protocol IQCollectionData: class {

        weak var section: IQCollectionSection? { get }

        func bind(_ section: IQCollectionSection)
        func unbind()
        
    }

#endif
