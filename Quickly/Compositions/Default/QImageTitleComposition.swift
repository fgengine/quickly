//
//  Quickly
//

open class QImageTitleCompositionData : QCompositionData {

    public var direction: QViewDirection
    public var image: QImageViewStyleSheet
    public var imageSize: CGSize
    public var imageSpacing: CGFloat

    public var title: QLabelStyleSheet

    public init(
        direction: QViewDirection,
        image: QImageViewStyleSheet,
        imageSize: CGSize,
        title: QLabelStyleSheet
    ) {
        self.direction = direction
        self.image = image
        self.imageSize = imageSize
        self.imageSpacing = 8
        self.title = title
        super.init()
    }

}

public class QImageTitleCompositionCell< DataType: QImageTitleCompositionData > : QComposition< DataType > {

    public private(set) var imageView: QImageView!
    public private(set) var titleLabel: QLabel!

    private var currentDirection: QViewDirection?
    private var currentEdgeInsets: UIEdgeInsets?
    private var currentImageSpacing: CGFloat?
    private var currentImageSize: CGSize?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    private var imageConstraints: [NSLayoutConstraint] = [] {
        willSet { self.imageView.removeConstraints(self.imageConstraints) }
        didSet { self.imageView.addConstraints(self.imageConstraints) }
    }

    open override class func size(data: DataType, size: CGSize) -> CGSize {
        let availableWidth = size.width - (data.edgeInsets.left + data.edgeInsets.right)
        switch data.direction {
        case .horizontal:
            let imageSize = data.image.source.size(CGSize(width: data.imageSize.width, height: availableWidth))
            let titleTextSize = data.title.text.size(width: availableWidth - (data.imageSize.width + data.imageSpacing))
            return CGSize(
                width: size.width,
                height: data.edgeInsets.top + max(imageSize.height, titleTextSize.height) + data.edgeInsets.bottom
            )
        case .vertical:
            let titleTextSize = data.title.text.size(width: availableWidth)
            return CGSize(
                width: data.edgeInsets.left + max(data.imageSize.width, titleTextSize.width) + data.edgeInsets.right,
                height: data.edgeInsets.top + data.imageSize.height + data.imageSpacing + titleTextSize.height + data.edgeInsets.bottom
            )
        }
    }

    open override func setup() {
        super.setup()

        self.imageView = QImageView(frame: self.contentView.bounds)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self.imageView)

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self.titleLabel)
    }

    open override func prepare(data: DataType, animated: Bool) {
        super.prepare(data: data, animated: animated)

        let changedDirection = self.currentDirection != data.direction
        self.currentDirection = data.direction
        let changedEdgeInsets = self.currentEdgeInsets != data.edgeInsets
        self.currentEdgeInsets = data.edgeInsets
        let changedImageSpacing = self.currentImageSpacing != data.imageSpacing
        self.currentImageSpacing = data.imageSpacing
        let changedImageSize = self.currentImageSize != data.imageSize
        self.currentImageSize = data.imageSize
        if changedDirection == true || changedEdgeInsets == true || changedImageSpacing == true {
            var selfConstraints: [NSLayoutConstraint] = []
            switch data.direction {
            case .horizontal:
                selfConstraints.append(self.imageView.topLayout == self.contentView.topLayout + data.edgeInsets.top)
                selfConstraints.append(self.imageView.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
                selfConstraints.append(self.imageView.trailingLayout == self.titleLabel.leadingLayout - data.imageSpacing)
                selfConstraints.append(self.imageView.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
                selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + data.edgeInsets.top)
                selfConstraints.append(self.titleLabel.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
                selfConstraints.append(self.titleLabel.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            case .vertical:
                selfConstraints.append(self.imageView.topLayout == self.contentView.topLayout + data.edgeInsets.top)
                selfConstraints.append(self.imageView.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
                selfConstraints.append(self.imageView.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
                selfConstraints.append(self.imageView.bottomLayout == self.titleLabel.topLayout - data.edgeInsets.bottom)
                selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
                selfConstraints.append(self.titleLabel.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
                selfConstraints.append(self.titleLabel.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            }
            self.selfConstraints = selfConstraints
        }
        if changedDirection == true || changedImageSize == true {
            var imageConstraints: [NSLayoutConstraint] = []
            switch data.direction {
            case .horizontal:
                imageConstraints.append(self.imageView.widthLayout == data.imageSize.width)
            case .vertical:
                imageConstraints.append(self.imageView.widthLayout == data.imageSize.width)
                imageConstraints.append(self.imageView.heightLayout == data.imageSize.height)
            }
            self.imageConstraints = imageConstraints
        }
        data.image.apply(target: self.imageView)
        data.title.apply(target: self.titleLabel)
    }

}
