//
//  Quickly
//

public protocol IQTableDecorDelegate : class {
}

public protocol IQTableDecor : IQTableReuse {

    typealias Dequeue = UITableViewHeaderFooterView & IQTableDecor

    var tableDelegate: IQTableDecorDelegate? { set get }

    static func dequeue(tableView: UITableView) -> Dequeue?

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

    public static func dequeue(tableView: UITableView) -> Dequeue? {
        return tableView.dequeueReusableHeaderFooterView(
            withIdentifier: self.reuseIdentifier()
        ) as? Dequeue
    }

}

public protocol IQTypedTableDecor : IQTableDecor {

    associatedtype Data: IQTableData

    static func height(data: Data, width: CGFloat) -> CGFloat

    func set(data: Data, animated: Bool)

}

extension IQTypedTableDecor {

    public static func using(any: Any) -> Bool {
        return any is Data
    }

    public static func usingLevel(any: AnyClass) -> UInt? {
        return inheritanceLevel(any, Data.self)
    }

    public static func height(any: Any, width: CGFloat) -> CGFloat {
        return self.height(data: any as! Data, width: width)
    }

    public func set(any: Any, animated: Bool) {
        self.set(data: any as! Data, animated: animated)
    }

}
