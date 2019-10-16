//
//  Quickly
//

open class QTableCell< RowType: IQTableRow > : UITableViewCell, IQTypedTableCell {

    open weak var tableDelegate: IQTableCellDelegate?
    open private(set) var row: RowType?
    open private(set) var spec: IQContainerSpec?

    open class func currentNibName() -> String {
        return String(describing: self.classForCoder())
    }

    open class func height(row: RowType, spec: IQContainerSpec) -> CGFloat {
        return UITableView.automaticDimension
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
        self.configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    open func setup() {
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }

    open func configure() {
    }

    open func set(row: RowType, spec: IQContainerSpec, animated: Bool) {
        self.row = row
        self.selectionStyle = row.selectionStyle
        self.spec = spec
    }

}
