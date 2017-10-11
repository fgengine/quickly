//
//  Quickly
//

#if os(iOS)

    open class QImageLabelTableCell< RowType: QImageLabelTableRow >: QBackgroundColorTableCell< RowType > {

        internal var pictureView: QImageView!
        internal var label: QLabel!
        internal var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            guard let imageSource: QImageSource = row.imageSource, let text: IQText = row.text else {
                return 0
            }
            let availableWidth: CGFloat = width - (row.edgeInsets.left + row.edgeInsets.right)
            let imageSize: CGSize = imageSource.size(available: CGSize(
                width: row.imageWidth, height: availableWidth
            ))
            let textSize: CGSize = text.size(width: availableWidth - (imageSize.width + row.spacing))
            return row.edgeInsets.top + max(imageSize.height, textSize.height) + row.edgeInsets.bottom
        }

        open override func setup() {
            super.setup()

            self.pictureView = QImageView(frame: self.contentView.bounds)
            self.pictureView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.pictureView)

            self.label = QLabel(frame: self.contentView.bounds)
            self.label.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.label)
        }

        open override func set(row: RowType) {
            super.set(row: row)
            self.apply(row: row)
        }

        open override func update(row: RowType) {
            super.update(row: row)
            self.apply(row: row)
        }

        private func apply(row: QImageLabelTableRow) {
            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.pictureView.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self.pictureView.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self.pictureView.trailingLayout == self.label.leadingLayout - row.spacing)
            selfConstraints.append(self.pictureView.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            selfConstraints.append(self.label.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self.label.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
            selfConstraints.append(self.label.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            self.selfConstraints = selfConstraints

            self.pictureView.roundCorners = row.imageRoundCorners
            self.pictureView.source = row.imageSource

            self.label.contentAlignment = row.textContentAlignment
            self.label.padding = row.textPadding
            self.label.numberOfLines = row.textNumberOfLines
            self.label.lineBreakMode = row.textLineBreakMode
            self.label.text = row.text
        }

    }

#endif
