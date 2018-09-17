//
//  Quickly
//

public protocol IQTableData : class {

    var section: IQTableSection? { get }
    var cacheHeight: CGFloat? { set get }

    func bind(_ section: IQTableSection)
    func unbind()
    
    func resetCacheHeight()

}
