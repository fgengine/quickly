//
//  Quickly
//

import UIKit

open class QCollectionItem : IQCollectionItem {

    public private(set) weak var section: IQCollectionSection?
    public private(set) var indexPath: IndexPath?
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

    public func unbind() {
        self.indexPath = nil
        self.section = nil
    }

}
