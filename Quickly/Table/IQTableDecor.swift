//
//  Quickly
//

public protocol IQTableDecorDelegate : class {
}

public protocol IQTableDecor : IQTableReuse {

    typealias DequeueType = UITableViewHeaderFooterView & IQTableDecor

    var tableDelegate: IQTableDecorDelegate? { set get }

    static func dequeue(tableView: UITableView) -> DequeueType?

    func configure()

    func set(any: Any, animated: Bool)

}

extension IQTableDecor where Self : UITableViewHeaderFooterView {

    public static func register(tableView: UITableView) {
        if let nib = self.currentNib() {
            tableView.register(nib, forHeaderFooterViewReuseIdentifier: self.reuseIdentifier())
        } else {
            tableView.register(self.classForCoder(), forHeaderFooterViewReuseIdentifier: self.reuseIdentifier())
        }
    }

    public static func dequeue(tableView: UITableView) -> DequeueType? {
        return tableView.dequeueReusableHeaderFooterView(
            withIdentifier: self.reuseIdentifier()
        ) as? DequeueType
    }

}

public protocol IQTypedTableDecor : IQTableDecor {

    associatedtype DataType: IQTableData

    static func height(data: DataType, width: CGFloat) -> CGFloat

    func set(data: DataType, animated: Bool)

}

extension IQTypedTableDecor {

    public static func using(any: Any) -> Bool {
        return any is DataType
    }

    public static func usingLevel(any: AnyClass) -> UInt? {
        return inheritanceLevel(any, DataType.self)
    }

    public static func height(any: Any, width: CGFloat) -> CGFloat {
        return self.height(data: any as! DataType, width: width)
    }

    public func set(any: Any, animated: Bool) {
        self.set(data: any as! DataType, animated: animated)
    }

}
