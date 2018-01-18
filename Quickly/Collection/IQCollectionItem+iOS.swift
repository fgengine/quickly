//
//  Quickly
//

#if os(iOS)

    public protocol IQCollectionItem: class {

        weak var section: IQCollectionSection? { get }
        var indexPath: IndexPath? { get }
        var canSelect: Bool { get }
        var canDeselect: Bool { get }
        var canMove: Bool { get }

        func bind(_ section: IQCollectionSection, _ indexPath: IndexPath)
        func rebind(_ indexPath: IndexPath)
        func unbind()

    }

#endif
