//
//  Quickly
//

public protocol IQTableCellDelegate : class {
}

public protocol IQTableCell : IQTableReuse {

    typealias DequeueType = UITableViewCell & IQTableCell

    var tableDelegate: IQTableCellDelegate? { set get }

    static func dequeue(tableView: UITableView, indexPath: IndexPath) -> DequeueType?

    func configure()

    func set(any: Any, animated: Bool)

}

extension IQTableCell where Self : UITableViewCell {

    public static func register(tableView: UITableView) {
        if let nib = self.currentNib() {
            tableView.register(nib, forCellReuseIdentifier: self.reuseIdentifier())
        } else {
            tableView.register(self.classForCoder(), forCellReuseIdentifier: self.reuseIdentifier())
        }
    }

    public static func dequeue(tableView: UITableView, indexPath: IndexPath) -> DequeueType? {
        return tableView.dequeueReusableCell(
            withIdentifier: self.reuseIdentifier(),
            for: indexPath
        ) as? DequeueType
    }

}

public protocol IQTypedTableCell : IQTableCell {

    associatedtype RowType: IQTableRow

    var row: RowType? { get }

    static func height(row: RowType, width: CGFloat) -> CGFloat

    func set(row: RowType, animated: Bool)

}

extension IQTypedTableCell {

    public static func using(any: Any) -> Bool {
        return any is RowType
    }

    public static func usingLevel(any: AnyClass) -> UInt? {
        return inheritanceLevel(any, RowType.self)
    }

    public static func height(any: Any, width: CGFloat) -> CGFloat {
        return self.height(row: any as! RowType, width: width)
    }

    public func set(any: Any, animated: Bool) {
        self.set(row: any as! RowType, animated: animated)
    }

}
