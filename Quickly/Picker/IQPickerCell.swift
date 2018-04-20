//
//  Quickly
//

public protocol IQPickerCell : IQView {

    typealias DequeueType = UIView & IQPickerCell

    static func using(any: Any) -> Bool

    static func dequeue(_ view: UIView?) -> DequeueType?

    func set(any: Any)

}

extension IQPickerCell where Self : UIView {

    public static func dequeue(_ view: UIView?) -> DequeueType? {
        if let view = view as? Self {
            return (view as DequeueType)
        }
        return (self.init() as DequeueType)
    }

}

public protocol IQTypedPickerCell : IQPickerCell {

    associatedtype RowType: IQPickerRow

    var row: RowType? { get }

    func set(row: RowType)

}

extension IQTypedPickerCell {

    public static func using(any: Any) -> Bool {
        return any is RowType
    }

    public func set(any: Any) {
        self.set(row: any as! RowType)
    }

}
