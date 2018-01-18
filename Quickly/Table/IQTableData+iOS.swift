//
//  Quickly
//

#if os(iOS)

    public protocol IQTableData: class {

        weak var section: IQTableSection? { get }

        func bind(_ section: IQTableSection)
        func unbind()

    }

#endif
