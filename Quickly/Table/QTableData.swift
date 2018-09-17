//
//  Quickly
//

open class QTableData : IQTableData {

    public private(set) weak var section: IQTableSection?
    public var cacheHeight: CGFloat?

    public init() {
    }

    public func bind(_ section: IQTableSection) {
        self.section = section
    }

    public func unbind() {
        self.section = nil
    }
    
    open func resetCacheHeight() {
        self.cacheHeight = 0
    }

}
