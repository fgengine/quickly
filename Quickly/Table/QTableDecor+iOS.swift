//
//  Quickly
//

#if os(iOS)

    open class QTableDecor<
        Type: IQTableData
    >: UITableViewHeaderFooterView, IQView, IQTypedTableDecor {

        open weak var tableDelegate: IQTableDecorDelegate? = nil
        open var data: Type? = nil

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

        open class func height(data: Type, width: CGFloat) -> CGFloat {
            return UITableViewAutomaticDimension
        }

        open func configure() {
        }

        open func set(data: Type) {
            self.data = data
        }

        open func update(data: Type) {
            self.data = data
        }

    }

#endif
