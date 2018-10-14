//
//  Quickly
//

open class QCollectionItem : IQCollectionItem {

    public weak var section: IQCollectionSection?
    public var indexPath: IndexPath?
    public var canSelect: Bool = true
    public var canDeselect: Bool = true
    public var canMove: Bool = false

    public init(
        canSelect: Bool = true,
        canDeselect: Bool = true,
        canMove: Bool = false
    ) {
        self.canSelect = canSelect
        self.canDeselect = canDeselect
        self.canSelect = canSelect
    }

    public func bind(_ section: IQCollectionSection, _ indexPath: IndexPath) {
        self.section = section
        self.indexPath = indexPath
    }

    public func rebind(_ indexPath: IndexPath) {
        self.indexPath = indexPath
    }

    public func unbind() {
        self.indexPath = nil
        self.section = nil
    }

}
