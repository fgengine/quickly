//
//  Quickly
//

open class QImageCollectionItem : QBackgroundColorCollectionItem {

    public var edgeInsets: UIEdgeInsets

    public var image: QImageViewStyleSheet

    public init(image: QImageViewStyleSheet) {
        self.edgeInsets = UIEdgeInsets.zero
        self.image = image

        super.init()
    }

}
