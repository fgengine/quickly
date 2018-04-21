//
//  Quickly
//

open class QImageCompositionData : QCompositionData {

    public var image: QImageViewStyleSheet

    public init(
        image: QImageViewStyleSheet
    ) {
        self.image = image
        super.init()
    }

}

public class QImageComposition< DataType: QImageCompositionData > : QComposition< DataType > {

    public private(set) var imageView: QImageView!

    private var currentEdgeInsets: UIEdgeInsets?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }

    open override class func size(data: DataType, size: CGSize) -> CGSize {
        let availableWidth = size.width - (data.edgeInsets.left + data.edgeInsets.right)
        let imageSize = data.image.source.size(CGSize(width: availableWidth, height: availableWidth))
        return CGSize(
            width: size.width,
            height: data.edgeInsets.top + imageSize.height + data.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.imageView = QImageView(frame: self.contentView.bounds)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.imageView)
    }

    open override func prepare(data: DataType, animated: Bool) {
        super.prepare(data: data, animated: animated)

        if self.currentEdgeInsets != data.edgeInsets {
            self.currentEdgeInsets = data.edgeInsets

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.imageView.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.imageView.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.imageView.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
            selfConstraints.append(self.imageView.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        data.image.apply(target: self.imageView)
    }

}
