//
//  Quickly
//

import UIKit

public protocol IQPickerCell : IQView {

    static func using(any: Any) -> Bool

    static func dequeue(_ view: UIView?) -> (UIView & IQPickerCell)?

    func set(any: Any)

}

extension IQPickerCell where Self : UIView {

    public static func dequeue(_ view: UIView?) -> (UIView & IQPickerCell)? {
        if let view = view as? Self {
            return (view as (UIView & IQPickerCell))
        }
        return (self.init() as (UIView & IQPickerCell))
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
