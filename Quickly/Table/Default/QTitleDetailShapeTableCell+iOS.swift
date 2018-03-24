//
//  Quickly
//

#if os(iOS)

    open class QTitleDetailShapeTableCell< RowType: QTitleDetailShapeTableRow >: QBackgroundColorTableCell< RowType > {

        private var _labelTitle: QLabel!
        private var _labelDetail: QLabel!
        private var _shape: QShapeView!

        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }
        private var shapeConstraints: [NSLayoutConstraint] = [] {
            willSet { self._shape.removeConstraints(self.shapeConstraints) }
            didSet { self._shape.addConstraints(self.shapeConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            guard
                let titleText: IQText = row.titleText,
                let detailText: IQText = row.detailText,
                let shapeModel: IQShapeModel = row.shapeModel
                else { return 0 }
            let availableWidth: CGFloat = width - (row.edgeInsets.left + row.edgeInsets.right)
            let titleTextSize: CGSize = titleText.size(width: availableWidth - (shapeModel.size.width + row.detailSpacing))
            let detailTextSize: CGSize = detailText.size(width: availableWidth - (shapeModel.size.width + row.detailSpacing))
            return row.edgeInsets.top + max(titleTextSize.height + row.titleSpacing + detailTextSize.height, shapeModel.size.height) + row.edgeInsets.bottom
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

        open override func set(row: RowType) {
            super.set(row: row)
            self.apply(row: row)
        }

        open override func update(row: RowType) {
            super.update(row: row)
            self.apply(row: row)
        }

        private func apply(row: QTitleDetailShapeTableRow) {
            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self._labelTitle.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self._labelTitle.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self._labelTitle.bottomLayout == self._labelDetail.topLayout - row.titleSpacing)
            selfConstraints.append(self._labelDetail.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self._labelDetail.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            selfConstraints.append(self._shape.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self._shape.leadingLayout == self._labelTitle.trailingLayout + row.detailSpacing)
            selfConstraints.append(self._shape.leadingLayout == self._labelDetail.trailingLayout + row.detailSpacing)
            selfConstraints.append(self._shape.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
            selfConstraints.append(self._shape.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            self.selfConstraints = selfConstraints

            var shapeConstraints: [NSLayoutConstraint] = []
            shapeConstraints.append(self._shape.widthLayout == row.shapeWidth)
            self.shapeConstraints = shapeConstraints

            self._labelTitle.contentAlignment = row.titleContentAlignment
            self._labelTitle.padding = row.titlePadding
            self._labelTitle.numberOfLines = row.titleNumberOfLines
            self._labelTitle.lineBreakMode = row.titleLineBreakMode
            self._labelTitle.text = row.titleText

            self._labelDetail.contentAlignment = row.detailContentAlignment
            self._labelDetail.padding = row.detailPadding
            self._labelDetail.numberOfLines = row.detailNumberOfLines
            self._labelDetail.lineBreakMode = row.detailLineBreakMode
            self._labelDetail.text = row.detailText

            self._shape.model = row.shapeModel
        }

    }

#endif
