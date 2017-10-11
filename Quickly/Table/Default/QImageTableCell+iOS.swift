//
//  Quickly
//

#if os(iOS)

    open class QImageTableCell< RowType: QImageTableRow >: QBackgroundColorTableCell< RowType > {

        internal var pictureView: QImageView!
        internal var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            guard let source: QImageSource = row.source else {
                return 0
            }
            let availableWidth: CGFloat = width - (row.edgeInsets.left + row.edgeInsets.right)
            let imageSize: CGSize = source.size(available: CGSize(
                width: availableWidth, height: availableWidth
            ))
            return row.edgeInsets.top + imageSize.height + row.edgeInsets.bottom
        }

        open override func setup() {
            super.setup()

            self.pictureView = QImageView(frame: self.contentView.bounds)
            self.pictureView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self.pictureView)
        }

        open override func set(row: RowType) {
            super.set(row: row)
            self.apply(row: row)
        }

        open override func update(row: RowType) {
            super.update(row: row)
            self.apply(row: row)
        }

        private func apply(row: QImageTableRow) {
            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.pictureView.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self.pictureView.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self.pictureView.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
            selfConstraints.append(self.pictureView.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            self.selfConstraints = selfConstraints

            self.pictureView.roundCorners = row.roundCorners
            self.pictureView.source = row.source
        }

    }

#endif

