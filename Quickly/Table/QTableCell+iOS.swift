//
//  Quickly
//

#if os(iOS)

    open class QTableCell<
        Type: IQTableRow
    >: UITableViewCell, IQView, IQTypedTableCell {

        public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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

        public weak var tableDelegate: IQTableCellDelegate? = nil
        public var row: Type? = nil

        open class func height(row: Type, width: CGFloat) -> CGFloat {
            return UITableViewAutomaticDimension
        }

        open func configure() {
        }

        open func set(row: Type) {
            self.row = row
            self.selectionStyle = row.selectionStyle
        }

        open func update(row: Type) {
            self.row = row
            self.selectionStyle = row.selectionStyle
        }

    }

#endif

