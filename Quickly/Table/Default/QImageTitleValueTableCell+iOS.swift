//
//  Quickly
//

#if os(iOS)

    open class QImageTitleValueTableCell< RowType: QImageTitleValueTableRow >: QBackgroundColorTableCell< RowType > {

        private var _image: QImageView!
        private var _labelTitle: QLabel!
        private var _labelValue: QLabel!

        private var currentEdgeInsets: UIEdgeInsets?
        private var currentImageSpacing: CGFloat?
        private var currentTitleSpacing: CGFloat?
        private var currentImageWidth: CGFloat?
        
        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }
        private var imageConstraints: [NSLayoutConstraint] = [] {
            willSet { self._image.removeConstraints(self.imageConstraints) }
            didSet { self._image.addConstraints(self.imageConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            let availableWidth = width - (row.edgeInsets.left + row.edgeInsets.right)
            let imageSize = row.image.source.size(CGSize(width: row.imageWidth, height: availableWidth))
            let valueTextSize = row.title.text.size(width: availableWidth - (row.imageWidth + row.imageSpacing))
            let titleTextSize = row.value.text.size(width: availableWidth - (row.imageWidth + row.imageSpacing + valueTextSize.width + row.titleSpacing))
            return row.edgeInsets.top + max(imageSize.height, titleTextSize.height, valueTextSize.height) + row.edgeInsets.bottom
        }

        open override func setup() {
            super.setup()

            self._image = QImageView(frame: self.contentView.bounds)
            self._image.translatesAutoresizingMaskIntoConstraints = false
            self._image.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .horizontal)
            self._image.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .vertical)
            self.contentView.addSubview(self._image)

            self._labelTitle = QLabel(frame: self.contentView.bounds)
            self._labelTitle.translatesAutoresizingMaskIntoConstraints = false
            self._labelTitle.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
            self._labelTitle.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
            self.contentView.addSubview(self._labelTitle)

            self._labelValue = QLabel(frame: self.contentView.bounds)
            self._labelValue.translatesAutoresizingMaskIntoConstraints = false
            self._labelValue.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
            self._labelValue.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
            self.contentView.addSubview(self._labelValue)
        }

        open override func set(row: RowType) {
            super.set(row: row)
            self.apply(row: row)
        }

        open override func update(row: RowType) {
            super.update(row: row)
            self.apply(row: row)
        }

        private func apply(row: QImageTitleValueTableRow) {
            if self.currentEdgeInsets != row.edgeInsets || self.currentImageSpacing != row.imageSpacing || self.currentTitleSpacing != row.titleSpacing {
                self.currentEdgeInsets = row.edgeInsets
                self.currentImageSpacing = row.imageSpacing
                self.currentTitleSpacing = row.titleSpacing

                var selfConstraints: [NSLayoutConstraint] = []
                selfConstraints.append(self._image.topLayout == self.contentView.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._image.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
                selfConstraints.append(self._image.trailingLayout == self._labelTitle.leadingLayout - row.imageSpacing)
                selfConstraints.append(self._image.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
                selfConstraints.append(self._labelTitle.topLayout == self.contentView.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._labelTitle.trailingLayout == self._labelValue.leadingLayout - row.titleSpacing)
                selfConstraints.append(self._labelTitle.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
                selfConstraints.append(self._labelValue.topLayout == self.contentView.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._labelValue.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
                selfConstraints.append(self._labelValue.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
                self.selfConstraints = selfConstraints
            }
            if self.currentImageWidth != row.imageWidth {
                self.currentImageWidth = row.imageWidth

                var imageConstraints: [NSLayoutConstraint] = []
                imageConstraints.append(self._image.widthLayout == row.imageWidth)
                self.imageConstraints = imageConstraints
            }
            row.image.apply(target: self._image)
            row.title.apply(target: self._labelTitle)
            row.value.apply(target: self._labelValue)
        }

    }

#endif
