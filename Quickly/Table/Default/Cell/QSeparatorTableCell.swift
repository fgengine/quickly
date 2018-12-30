//
//  Quickly
//

open class QSeparatorTableRow : QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets
    public var color: UIColor

    public init(color: UIColor, backgroundColor: UIColor? = nil, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero) {
        self.edgeInsets = edgeInsets
        self.color = color
        super.init(backgroundColor: backgroundColor)
        self.canSelect = false
    }

}

open class QSeparatorTableCell< RowType: QSeparatorTableRow > : QBackgroundColorTableCell< RowType > {

    private var _separator: QView!

    private var _edgeInsets: UIEdgeInsets?

    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self._constraints) }
        didSet { self.contentView.addConstraints(self._constraints) }
    }

    open override class func height(row: RowType, spec: IQContainerSpec) -> CGFloat {
        return row.edgeInsets.top + (1 / UIScreen.main.scale) + row.edgeInsets.bottom
    }

    open override func setup() {
        super.setup()

        self._separator = QView(frame: self.contentView.bounds)
        self._separator.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self._separator)
    }

    open override func set(row: RowType, spec: IQContainerSpec, animated: Bool) {
        super.set(row: row, spec: spec, animated: animated)
        
        if self._edgeInsets != row.edgeInsets {
            self._edgeInsets = row.edgeInsets
            self._constraints = [
                self._separator.topLayout == self.contentView.topLayout + row.edgeInsets.top,
                self._separator.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left,
                self._separator.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right,
                self._separator.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom
            ]
        }
        self._separator.backgroundColor = row.color
    }

}
