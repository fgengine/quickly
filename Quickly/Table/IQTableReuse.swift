//
//  Quickly
//

public protocol IQTableReuse : IQView {

    static func reuseIdentifier() -> String
    static func currentNib() -> UINib?
    static func currentNibName() -> String
    static func currentNibBundle() -> Bundle

    static func register(tableView: UITableView)

    static func height(any: Any, spec: IQContainerSpec) -> CGFloat

    static func using(any: Any) -> Bool
    static func usingLevel(any: AnyClass) -> UInt?

}

extension IQTableReuse where Self : UIView {

    public static func reuseIdentifier() -> String {
        return NSStringFromClass(self)
    }

    public static func currentNib() -> UINib? {
        let nibName = self.currentNibName()
        let bundle = self.currentNibBundle()
        if bundle.url(forResource: nibName, withExtension: "nib") == nil {
            return nil
        }
        return UINib(nibName: nibName, bundle: bundle)
    }

    public static func currentNibName() -> String {
        return String(describing: self.classForCoder())
    }

    public static func currentNibBundle() -> Bundle {
        return Bundle.main
    }

}
