//
//  Quickly
//

#if os(iOS)

    public protocol IQCollectionItem: class {

        var canSelect: Bool { get }
        var canDeselect: Bool { get }
        var canMove: Bool { get }

    }

#endif
