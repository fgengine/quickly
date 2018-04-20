//
//  Quickly
//

open class QImageTableCell< RowType: QImageTableRow >: QBackgroundColorTableCell< RowType > {

    private var _image: QImageView!

    private var currentEdgeInsets: UIEdgeInsets?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func height(row: RowType, width: CGFloat) -> CGFloat {
        let availableWidth = width - (row.edgeInsets.left + row.edgeInsets.right)
        let imageSize = row.image.source.size(CGSize(width: availableWidth, height: availableWidth))
        return row.edgeInsets.top + imageSize.height + row.edgeInsets.bottom
    }

    open override func setup() {
        super.setup()

        self._image = QImageView(frame: self.contentView.bounds)
        self._image.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self._image)
    }

    open override func set(row: RowType, animated: Bool) {
        super.set(row: row, animated: animated)
        
        if self.currentEdgeInsets != row.edgeInsets {
            self.currentEdgeInsets = row.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self._image.topLayout == self.contentView.topLayout + row.edgeInsets.top)
            selfConstraints.append(self._image.leadingLayout == self.contentView.leadingLayout + row.edgeInsets.left)
            selfConstraints.append(self._image.trailingLayout == self.contentView.trailingLayout - row.edgeInsets.right)
            selfConstraints.append(self._image.bottomLayout == self.contentView.bottomLayout - row.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        row.image.apply(target: self._image)
    }

}
