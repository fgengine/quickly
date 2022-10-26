//
//  Quickly
//

import UIKit

public protocol IQTableDecorDelegate : AnyObject {
}

public protocol IQTableDecor : IQTableReuse {

    var tableDelegate: IQTableDecorDelegate? { set get }

    static func dequeue(tableView: UITableView) -> (UITableViewHeaderFooterView & IQTableDecor)?

    func configure()

    func prepare(any: Any, spec: IQContainerSpec, animated: Bool)
    
    func beginDisplay()
    func endDisplay()

}

extension IQTableDecor where Self : UITableViewHeaderFooterView {

    public static func register(tableView: UITableView) {
        if let nib = self.currentNib() {
            tableView.register(nib, forHeaderFooterViewReuseIdentifier: self.reuseIdentifier())
        } else {
            tableView.register(self.classForCoder(), forHeaderFooterViewReuseIdentifier: self.reuseIdentifier())
        }
    }

    public static func dequeue(tableView: UITableView) -> (UITableViewHeaderFooterView & IQTableDecor)? {
        return tableView.dequeueReusableHeaderFooterView(
            withIdentifier: self.reuseIdentifier()
        ) as? (UITableViewHeaderFooterView & IQTableDecor)
    }

}

public protocol IQTypedTableDecor : IQTableDecor {

    associatedtype DataType: IQTableData

    static func height(data: DataType, spec: IQContainerSpec) -> CGFloat

    func prepare(data: DataType, spec: IQContainerSpec, animated: Bool)

}

extension IQTypedTableDecor {

    public static func using(any: Any) -> Bool {
        return any is DataType
    }

    public static func usingLevel(any: AnyClass) -> UInt? {
        return QInheritanceLevel(any, DataType.self)
    }

    public static func height(any: Any, spec: IQContainerSpec) -> CGFloat {
        return self.height(data: any as! DataType, spec: spec)
    }

    public func prepare(any: Any, spec: IQContainerSpec, animated: Bool) {
        self.prepare(data: any as! DataType, spec: spec, animated: animated)
    }

}
