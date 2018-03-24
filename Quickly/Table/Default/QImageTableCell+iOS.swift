//
//  Quickly
//

#if os(iOS)

    public class QImageTableCell< RowType: QImageTableRow >: QBackgroundColorTableCell< RowType > {

        private var _image: QImageView!
        
        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            guard
                let imageSource: QImageSource = row.imageSource
                else { return 0 }
            let availableWidth: CGFloat = width - (row.edgeInsets.left + row.edgeInsets.right)
            let imageSize: CGSize = imageSource.size(CGSize(
                width: availableWidth, height: availableWidth
            ))
            return row.edgeInsets.top + imageSize.height + row.edgeInsets.bottom
        }

        open override func setup() {
            super.setup()

            self._image = QImageView(frame: self.contentView.bounds)
            self._image.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(self._image)
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
            selfConstraints.append(self._image.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self._image.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self._image.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
            selfConstraints.append(self._image.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            self.selfConstraints = selfConstraints

            self._image.layer.cornerRadius = row.imageCornerRadius
            self._image.roundCorners = row.imageRoundCorners
            self._image.source = row.imageSource
        }

    }

#endif

