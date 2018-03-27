//
//  Quickly
//

#if os(iOS)

    public class QImageTitleValueTableCell< RowType: QImageTitleValueTableRow >: QBackgroundColorTableCell< RowType > {

        private var _image: QImageView!
        private var _labelTitle: QLabel!
        private var _labelValue: QLabel!

        private var currentEdgeInsets: UIEdgeInsets?
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
            guard
                let imageSource: QImageSource = row.imageSource,
                let titleText: IQText = row.titleText,
                let valueText: IQText = row.valueText
                else { return 0 }
            let availableWidth: CGFloat = width - (row.edgeInsets.left + row.edgeInsets.right)
            let imageSize: CGSize = imageSource.size(CGSize(
                width: row.imageWidth, height: availableWidth
            ))
            let valueTextSize: CGSize = valueText.size(width: availableWidth - (imageSize.width + row.imageSpacing))
            let titleTextSize: CGSize = titleText.size(width: availableWidth - (imageSize.width + row.imageSpacing + valueTextSize.width + row.titleSpacing))
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
            if self.currentEdgeInsets != row.edgeInsets {
                self.currentEdgeInsets = row.edgeInsets

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

            self._image.layer.cornerRadius = row.imageCornerRadius
            self._image.roundCorners = row.imageRoundCorners
            self._image.source = row.imageSource

            self._labelTitle.contentAlignment = row.titleContentAlignment
            self._labelTitle.padding = row.titlePadding
            self._labelTitle.numberOfLines = row.titleNumberOfLines
            self._labelTitle.lineBreakMode = row.titleLineBreakMode
            self._labelTitle.text = row.titleText

            self._labelValue.contentAlignment = row.valueContentAlignment
            self._labelValue.padding = row.valuePadding
            self._labelValue.numberOfLines = row.valueNumberOfLines
            self._labelValue.lineBreakMode = row.valueLineBreakMode
            self._labelValue.text = row.valueText
        }

    }

#endif
