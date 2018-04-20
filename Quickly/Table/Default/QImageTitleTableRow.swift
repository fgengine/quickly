//
//  Quickly
//

open class QImageTitleTableRow : QBackgroundColorTableRow {

    public var edgeInsets: UIEdgeInsets

    public var image: QImageViewStyleSheet
    public var imageWidth: CGFloat
    public var imageSpacing: CGFloat

    public var title: QLabelStyleSheet

    public init(image: QImageViewStyleSheet, imageWidth: CGFloat, title: QLabelStyleSheet) {
        self.edgeInsets = UIEdgeInsets.zero
        self.image = image
        self.imageWidth = imageWidth
        self.imageSpacing = 0
        self.title = title

        super.init()
    }

}
