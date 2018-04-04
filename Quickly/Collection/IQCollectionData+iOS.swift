//
//  Quickly
//

#if os(iOS)

    public protocol IQCollectionData : class {

        var section: IQCollectionSection? { get }

        func bind(_ section: IQCollectionSection)
        func unbind()
        
    }

#endif
