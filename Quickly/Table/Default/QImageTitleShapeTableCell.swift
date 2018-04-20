//
//  Quickly
//

open class QImageTitleShapeTableCell< RowType: QImageTitleShapeTableRow >: QBackgroundColorTableCell< RowType > {

    private var _image: QImageView!
    private var _labelTitle: QLabel!
    private var _shape: QShapeView!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentImageWidth: CGFloat?
    private var currentImageSpacing: CGFloat?
    private var currentShapeWidth: CGFloat?
    private var currentShapeSpacing: CGFloat?

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
        let availableWidth = width - (row.edgeInsets.left + row.edgeInsets.right)
        let imageSize = row.image.source.size(CGSize(width: row.imageWidth, height: availableWidth))
        let titleTextSize = row.title.text.size(width: availableWidth - (row.imageWidth + row.imageSpacing + row.shapeWidth + row.shapeSpacing))
        return row.edgeInsets.top + max(imageSize.height, titleTextSize.height, row.shape.size.height) + row.edgeInsets.bottom
    }

    open override func setup() {
        super.setup()

        self._image = QImageView(frame: self.contentView.bounds)
        self._image.translatesAutoresizingMaskIntoConstraints = false
        self._image.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self._image.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self._image)

        self._labelTitle = QLabel(frame: self.contentView.bounds)
        self._labelTitle.translatesAutoresizingMaskIntoConstraints = false
        self._labelTitle.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self._labelTitle.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self._labelTitle)

        self._shape = QShapeView(frame: self.contentView.bounds)
        self._shape.translatesAutoresizingMaskIntoConstraints = false
        self._shape.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .horizontal)
        self._shape.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .vertical)
        self.contentView.addSubview(self._shape)
    }

    open override func set(row: RowType, animated: Bool) {
        super.set(row: row, animated: animated)
        
        if self.currentEdgeInsets != row.edgeInsets || self.currentImageSpacing != row.imageSpacing || self.currentShapeSpacing != row.shapeSpacing {
            self.currentEdgeInsets = row.edgeInsets
            self.currentImageSpacing = row.imageSpacing
            self.currentShapeSpacing = row.shapeSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self._image.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self._image.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self._image.trailingLayout == self._labelTitle.leadingLayout - row.imageSpacing)
            selfConstraints.append(self._image.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            selfConstraints.append(self._labelTitle.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self._labelTitle.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            selfConstraints.append(self._shape.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self._shape.leadingLayout == self._labelTitle.trailingLayout + row.shapeSpacing)
            selfConstraints.append(self._shape.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
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
        row.image.apply(target: self._image)
        row.title.apply(target: self._labelTitle)
        self._shape.model = row.shape
    }

}
