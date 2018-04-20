//
//  Quickly
//

open class QTitleDetailShapeTableCell< RowType: QTitleDetailShapeTableRow >: QBackgroundColorTableCell< RowType > {

    private var _labelTitle: QLabel!
    private var _labelDetail: QLabel!
    private var _shape: QShapeView!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentTitleSpacing: CGFloat?
    private var currentShapeWidth: CGFloat?
    private var currentShapeSpacing: CGFloat?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    private var shapeConstraints: [NSLayoutConstraint] = [] {
        willSet { self._shape.removeConstraints(self.shapeConstraints) }
        didSet { self._shape.addConstraints(self.shapeConstraints) }
    }

    open override class func height(row: RowType, width: CGFloat) -> CGFloat {
        let availableWidth = width - (row.edgeInsets.left + row.edgeInsets.right)
        let titleTextSize = row.title.text.size(width: availableWidth - (row.shapeWidth + row.shapeSpacing))
        let detailTextSize = row.detail.text.size(width: availableWidth - (row.shapeWidth + row.shapeSpacing))
        return row.edgeInsets.top + max(titleTextSize.height + row.titleSpacing + detailTextSize.height, row.shape.size.height) + row.edgeInsets.bottom
    }

    open override func setup() {
        super.setup()

        self._labelTitle = QLabel(frame: self.contentView.bounds)
        self._labelTitle.translatesAutoresizingMaskIntoConstraints = false
        self._labelTitle.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self._labelTitle.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .vertical)
        self.contentView.addSubview(self._labelTitle)

        self._labelDetail = QLabel(frame: self.contentView.bounds)
        self._labelDetail.translatesAutoresizingMaskIntoConstraints = false
        self._labelDetail.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self._labelDetail.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self._labelDetail)

        self._shape = QShapeView(frame: self.contentView.bounds)
        self._shape.translatesAutoresizingMaskIntoConstraints = false
        self._shape.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self._shape.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self._shape)
}

    open override func set(row: RowType, animated: Bool) {
        super.set(row: row, animated: animated)
        
        if self.currentEdgeInsets != row.edgeInsets || self.currentTitleSpacing != row.titleSpacing || self.currentShapeSpacing != row.shapeSpacing {
            self.currentEdgeInsets = row.edgeInsets
            self.currentTitleSpacing = row.titleSpacing
            self.currentShapeSpacing = row.shapeSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self._labelTitle.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self._labelTitle.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self._labelTitle.bottomLayout == self._labelDetail.topLayout - row.titleSpacing)
            selfConstraints.append(self._labelDetail.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self._labelDetail.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            selfConstraints.append(self._shape.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self._shape.leadingLayout == self._labelTitle.trailingLayout + row.shapeSpacing)
            selfConstraints.append(self._shape.leadingLayout == self._labelDetail.trailingLayout + row.shapeSpacing)
            selfConstraints.append(self._shape.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
            selfConstraints.append(self._shape.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        if self.currentShapeWidth != row.shapeWidth {
            self.currentShapeWidth = row.shapeWidth

            var shapeConstraints: [NSLayoutConstraint] = []
            shapeConstraints.append(self._shape.widthLayout == row.shapeWidth)
            self.shapeConstraints = shapeConstraints
        }
        row.title.apply(target: self._labelTitle)
        row.detail.apply(target: self._labelDetail)
        self._shape.model = row.shape
    }

}
