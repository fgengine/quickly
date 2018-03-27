//
//  Quickly
//

#if os(iOS)

    public class QImageTitleDetailShapeTableCell< RowType: QImageTitleDetailShapeTableRow >: QBackgroundColorTableCell< RowType > {

        private var _image: QImageView!
        private var _labelTitle: QLabel!
        private var _labelDetail: QLabel!
        private var _shape: QShapeView!

        private var currentEdgeInsets: UIEdgeInsets?
        private var currentImageWidth: CGFloat?
        private var currentShapeWidth: CGFloat?
        
        private var selfConstraints: [NSLayoutConstraint] = [] {
            willSet { self.contentView.removeConstraints(self.selfConstraints) }
            didSet { self.contentView.addConstraints(self.selfConstraints) }
        }
        private var imageConstraints: [NSLayoutConstraint] = [] {
            willSet { self._image.removeConstraints(self.imageConstraints) }
            didSet { self._image.addConstraints(self.imageConstraints) }
        }
        private var shapeConstraints: [NSLayoutConstraint] = [] {
            willSet { self._shape.removeConstraints(self.shapeConstraints) }
            didSet { self._shape.addConstraints(self.shapeConstraints) }
        }

        open override class func height(row: RowType, width: CGFloat) -> CGFloat {
            guard
                let imageSource: QImageSource = row.imageSource,
                let titleText: IQText = row.titleText,
                let detailText: IQText = row.detailText,
                let shapeModel: IQShapeModel = row.shapeModel
                else { return 0 }
            let availableWidth: CGFloat = width - (row.edgeInsets.left + row.edgeInsets.right)
            let imageSize: CGSize = imageSource.size(CGSize(
                width: row.imageWidth, height: availableWidth
            ))
            let titleTextSize: CGSize = titleText.size(width: availableWidth - (imageSize.width + row.imageSpacing))
            let detailTextSize: CGSize = detailText.size(width: availableWidth - (imageSize.width + row.imageSpacing))
            return row.edgeInsets.top + max(imageSize.height, titleTextSize.height + row.titleSpacing + detailTextSize.height, shapeModel.size.height) + row.edgeInsets.bottom
        }

        open override func setup() {
            super.setup()

            self._image = QImageView(frame: self.contentView.bounds)
            self._image.translatesAutoresizingMaskIntoConstraints = false
            self._image.setContentHuggingPriority(UILayoutPriority(rawValue: 254), for: .horizontal)
            self._image.setContentHuggingPriority(UILayoutPriority(rawValue: 254), for: .vertical)
            self.contentView.addSubview(self._image)

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

            self._shape = QShapeView(frame: self.contentView.bounds)
            self._shape.translatesAutoresizingMaskIntoConstraints = false
            self._shape.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .horizontal)
            self._shape.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .vertical)
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

        private func apply(row: QImageTitleDetailShapeTableRow) {
            if self.currentEdgeInsets != row.edgeInsets {
                self.currentEdgeInsets = row.edgeInsets

                var selfConstraints: [NSLayoutConstraint] = []
                selfConstraints.append(self._image.topLayout == self.contentView.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._image.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
                selfConstraints.append(self._image.trailingLayout == self._labelTitle.leadingLayout - row.imageSpacing)
                selfConstraints.append(self._image.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
                selfConstraints.append(self._labelTitle.topLayout == self.contentView.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._labelTitle.trailingLayout == self._shape.leadingLayout - row.shapeSpacing)
                selfConstraints.append(self._labelTitle.bottomLayout == self._labelDetail.topLayout - row.titleSpacing)
                selfConstraints.append(self._labelDetail.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
                selfConstraints.append(self._labelDetail.trailingLayout == self._shape.leadingLayout - row.shapeSpacing)
                selfConstraints.append(self._labelDetail.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
                selfConstraints.append(self._shape.topLayout == self.contentView.topLayout + row.edgeInsets.top)
                selfConstraints.append(self._shape.leadingLayout == self._labelTitle.trailingLayout + row.shapeSpacing)
                selfConstraints.append(self._shape.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
                self.selfConstraints = selfConstraints
            }
            if self.currentImageWidth != row.imageWidth {
                self.currentImageWidth = row.imageWidth

                var imageConstraints: [NSLayoutConstraint] = []
                imageConstraints.append(self._image.widthLayout == row.imageWidth)
                self.imageConstraints = imageConstraints
            }
            if self.currentShapeWidth != row.shapeWidth {
                self.currentShapeWidth = row.shapeWidth

                var shapeConstraints: [NSLayoutConstraint] = []
                shapeConstraints.append(self._shape.widthLayout == row.shapeWidth)
                self.shapeConstraints = shapeConstraints
            }

            self._image.layer.cornerRadius = row.imageCornerRadius
            self._image.roundCorners = row.imageRoundCorners
            self._image.source = row.imageSource

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
