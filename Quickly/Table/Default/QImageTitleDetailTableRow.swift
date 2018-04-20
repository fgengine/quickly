//
//  Quickly
//

open class QImageTitleDetailTableRow : QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets

    public var image: QImageViewStyleSheet
    public var imageWidth: CGFloat
    public var imageSpacing: CGFloat

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var detail: QLabelStyleSheet

    public init(image: QImageViewStyleSheet, title: QLabelStyleSheet, detail: QLabelStyleSheet) {
        self.edgeInsets = UIEdgeInsets.zero
        self.image = image
        self.imageWidth = 96
        self.imageSpacing = 0
        self.title = title
        self.titleSpacing = 0
        self.detail = detail

        super.init()
    }

}
