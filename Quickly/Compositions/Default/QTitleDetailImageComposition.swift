//
//  Quickly
//

open class QTitleDetailImageCompositionData : QCompositionData {

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var detail: QLabelStyleSheet

    public var image: QImageViewStyleSheet
    public var imageWidth: CGFloat
    public var imageSpacing: CGFloat

    public init(
        title: QLabelStyleSheet,
        detail: QLabelStyleSheet,
        image: QImageViewStyleSheet
    ) {
        self.title = title
        self.titleSpacing = 4
        self.detail = detail
        self.image = image
        self.imageWidth = 16
        self.imageSpacing = 8
        super.init()
    }

}

public class QTitleDetailImageComposition< DataType: QTitleDetailImageCompositionData >: QComposition< DataType > {

    public private(set) var titleLabel: QLabel!
    public private(set) var detailLabel: QLabel!
    public private(set) var imageView: QImageView!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentTitleSpacing: CGFloat?
    private var currentImageWidth: CGFloat?
    private var currentImageSpacing: CGFloat?

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
        let titleTextSize = data.title.text.size(width: availableWidth - (data.imageWidth + data.imageSpacing))
        let detailTextSize = data.detail.text.size(width: availableWidth - (data.imageWidth + data.imageSpacing))
        let imageSize = data.image.source.size(CGSize(width: data.imageWidth, height: availableWidth))
        return CGSize(
            width: size.width,
            height: data.edgeInsets.top + max(titleTextSize.height + data.titleSpacing + detailTextSize.height, imageSize.height) + data.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .vertical)
        self.contentView.addSubview(self.titleLabel)

        self.detailLabel = QLabel(frame: self.contentView.bounds)
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.detailLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self.detailLabel)

        self.imageView = QImageView(frame: self.contentView.bounds)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self.imageView)
}

    open override func prepare(data: DataType, animated: Bool) {
        super.prepare(data: data, animated: animated)
        
        if self.currentEdgeInsets != data.edgeInsets || self.currentTitleSpacing != data.titleSpacing || self.currentImageSpacing != data.imageSpacing {
            self.currentEdgeInsets = data.edgeInsets
            self.currentTitleSpacing = data.titleSpacing
            self.currentImageSpacing = data.imageSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.titleLabel.bottomLayout == self.detailLabel.topLayout - data.titleSpacing)
            selfConstraints.append(self.detailLabel.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.detailLabel.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            selfConstraints.append(self.imageView.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.imageView.leadingLayout == self.titleLabel.trailingLayout + data.imageSpacing)
            selfConstraints.append(self.imageView.leadingLayout == self.detailLabel.trailingLayout + data.imageSpacing)
            selfConstraints.append(self.imageView.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
            selfConstraints.append(self.imageView.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        if self.currentImageWidth != data.imageWidth {
            self.currentImageWidth = data.imageWidth

            var imageConstraints: [NSLayoutConstraint] = []
            imageConstraints.append(self.imageView.widthLayout == data.imageWidth)
            self.imageConstraints = imageConstraints
        }
        data.title.apply(target: self.titleLabel)
        data.detail.apply(target: self.detailLabel)
        data.image.apply(target: self.imageView)
    }

}
