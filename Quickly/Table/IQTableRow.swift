//
//  Quickly
//

public protocol IQTableRow : class {

    var section: IQTableSection? { get }
    
    var indexPath: IndexPath? { get }
    
    var canSelect: Bool { get }
    
    var canEdit: Bool { get }
    
    var canMove: Bool { get }
    
    var selectionStyle: UITableViewCell.SelectionStyle { get }
    
    var editingStyle: UITableViewCell.EditingStyle { get }
    
    @available(iOS 11.0, *)
    var leadingSwipeConfiguration: UISwipeActionsConfiguration? { get }
    
    @available(iOS 11.0, *)
    var trailingSwipeConfiguration: UISwipeActionsConfiguration? { get }
    
    var cacheHeight: CGFloat? { set get }

    func bind(_ section: IQTableSection, _ indexPath: IndexPath)
    
    func unbind()
    
    func resetCacheHeight()

}
