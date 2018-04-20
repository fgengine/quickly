//
//  Quickly
//

open class QTitleDetailTableCell< RowType: QTitleDetailTableRow >: QBackgroundColorTableCell< RowType > {

    private var _labelTitle: QLabel!
    private var _labelDetail: QLabel!

    private var currentEdgeInsets: UIEdgeInsets?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func height(row: RowType, width: CGFloat) -> CGFloat {
        let availableWidth = width - (row.edgeInsets.left + row.edgeInsets.right)
        let titleTextSize = row.title.text.size(width: availableWidth)
        let detailTextSize = row.detail.text.size(width: availableWidth)
        return row.edgeInsets.top + titleTextSize.height + row.titleSpacing + detailTextSize.height + row.edgeInsets.bottom
    }

    open override func setup() {
        super.setup()

        self._labelTitle = QLabel(frame: self.contentView.bounds)
        self._labelTitle.translatesAutoresizingMaskIntoConstraints = false
        self._labelTitle.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self._labelTitle.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self._labelTitle)

        self._labelDetail = QLabel(frame: self.contentView.bounds)
        self._labelDetail.translatesAutoresizingMaskIntoConstraints = false
        self._labelDetail.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self._labelDetail.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self._labelDetail)
    }

    open override func set(row: RowType, animated: Bool) {
        super.set(row: row, animated: animated)
        
        if self.currentEdgeInsets != row.edgeInsets {
            self.currentEdgeInsets = row.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self._labelTitle.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self._labelTitle.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self._labelTitle.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
            selfConstraints.append(self._labelTitle.bottomLayout == self._labelDetail.topLayout - row.titleSpacing)
            selfConstraints.append(self._labelDetail.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self._labelDetail.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
            selfConstraints.append(self._labelDetail.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        row.title.apply(target: self._labelTitle)
        row.detail.apply(target: self._labelDetail)
    }

}
