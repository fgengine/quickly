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

    func set(any: Any, spec: IQContainerSpec, animated: Bool)

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

    static func height(data: Data, spec: IQContainerSpec) -> CGFloat

    func set(data: Data, spec: IQContainerSpec, animated: Bool)

}

extension IQTypedTableDecor {

    public static func using(any: Any) -> Bool {
        return any is Data
    }

    public static func usingLevel(any: AnyClass) -> UInt? {
        return inheritanceLevel(any, Data.self)
    }

    public static func height(any: Any, spec: IQContainerSpec) -> CGFloat {
        return self.height(data: any as! Data, spec: spec)
    }

    public func set(any: Any, spec: IQContainerSpec, animated: Bool) {
        self.set(data: any as! Data, spec: spec, animated: animated)
    }

}
