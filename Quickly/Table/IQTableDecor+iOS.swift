//
//  Quickly
//

#if os(iOS)

    public protocol IQTableDecorDelegate: class {
    }

    public protocol IQTableDecor: IQTableReuse {

        weak var tableDelegate: IQTableDecorDelegate? { set get }

        static func dequeue(tableView: UITableView) -> UITableViewHeaderFooterView?

        func configure()

        func set(any: Any)
        func update(any: Any)

    }

    extension IQTableDecor where Self: UIView {

        public static func register(tableView: UITableView) {
            if let nib: UINib = self.currentNib() {
                tableView.register(nib, forHeaderFooterViewReuseIdentifier: self.reuseIdentifier())
            } else {
                tableView.register(self.classForCoder(), forHeaderFooterViewReuseIdentifier: self.reuseIdentifier())
            }
        }

        public static func dequeue(tableView: UITableView) -> UITableViewHeaderFooterView? {
            return tableView.dequeueReusableHeaderFooterView(withIdentifier: self.reuseIdentifier())
        }

    }

    public protocol IQTypedTableDecor: IQTableDecor {

        associatedtype DataType: IQTableData

        static func height(data: DataType, width: CGFloat) -> CGFloat

        func set(data: DataType)
        func update(data: DataType)

    }

    extension IQTypedTableDecor {

        public static func using(any: Any) -> Bool {
            return any is DataType
        }

        public static func height(any: Any, width: CGFloat) -> CGFloat {
            return self.height(data: any as! DataType, width: width)
        }

        public func set(any: Any) {
            self.set(data: any as! DataType)
        }

        public func update(any: Any) {
            self.update(data: any as! DataType)
        }

    }

#endif

