//
//  Quickly
//

#if os(iOS)

    open class QCollectionItem : IQCollectionItem {

        public weak var section: IQCollectionSection? = nil
        public var indexPath: IndexPath? = nil
        public var canSelect: Bool = true
        public var canDeselect: Bool = true
        public var canMove: Bool = false

        public init() {
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

#endif
