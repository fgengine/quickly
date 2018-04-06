//
//  Quickly
//

#if os(iOS)

    public protocol IQTableDecorDelegate : class {
    }

    public protocol IQTableDecor : IQTableReuse {

        typealias DequeueType = UITableViewHeaderFooterView & IQTableDecor

        var tableDelegate: IQTableDecorDelegate? { set get }

        static func dequeue(tableView: UITableView) -> DequeueType?

        func configure()

        func set(any: Any)
        func update(any: Any)

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

        func set(data: DataType)
        func update(data: DataType)

    }

    extension IQTypedTableDecor {

        public static func using(any: Any) -> Bool {
            return any is DataType
        }

        public static func usingLevel(any: AnyClass) -> UInt? {
            var selfclass: AnyClass = any
            var level: UInt = 0
            while selfclass !== DataType.self {
                guard let superclass = selfclass.superclass() else { return nil }
                selfclass = superclass
                level += 1
            }
            return level
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

