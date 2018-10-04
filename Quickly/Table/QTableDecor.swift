//
//  Quickly
//

open class QTableDecor< DataType: IQTableData > : UITableViewHeaderFooterView, IQTypedTableDecor {

    open weak var tableDelegate: IQTableDecorDelegate?
    open var data: DataType?

    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setup()
        self.configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    open func setup() {
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }

    open class func height(data: DataType, spec: IQContainerSpec) -> CGFloat {
        return UITableView.automaticDimension
    }

    open func configure() {
    }

    open func set(data: DataType, spec: IQContainerSpec, animated: Bool) {
        self.data = data
    }

}
