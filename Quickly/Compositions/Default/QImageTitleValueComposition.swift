//
//  Quickly
//

open class QImageTitleValueCompositionData : QCompositionData {

    public var image: QImageViewStyleSheet
    public var imageWidth: CGFloat
    public var imageSpacing: CGFloat

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var value: QLabelStyleSheet

    public init(
        image: QImageViewStyleSheet,
        title: QLabelStyleSheet,
        value: QLabelStyleSheet
    ) {
        self.image = image
        self.imageWidth = 96
        self.imageSpacing = 8
        self.title = title
        self.titleSpacing = 4
        self.value = value

        super.init()
    }

}

public class QImageTitleValueComposition< DataType: QImageTitleValueCompositionData > : QComposition< DataType > {

    public private(set) var imageView: QImageView!
    public private(set) var titleLabel: QLabel!
    public private(set) var valueLabel: QLabel!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentImageSpacing: CGFloat?
    private var currentTitleSpacing: CGFloat?
    private var currentImageWidth: CGFloat?

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
        let imageSize = data.image.source.size(CGSize(width: data.imageWidth, height: availableWidth))
        let valueTextSize = data.title.text.size(width: availableWidth - (data.imageWidth + data.imageSpacing))
        let titleTextSize = data.value.text.size(width: availableWidth - (data.imageWidth + data.imageSpacing + valueTextSize.width + data.titleSpacing))
        return CGSize(
            width: size.width,
            height: data.edgeInsets.top + max(imageSize.height, titleTextSize.height, valueTextSize.height) + data.edgeInsets.bottom
        )
    }

    open override func setup() {
        super.setup()

        self.imageView = QImageView(frame: self.contentView.bounds)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .horizontal)
        self.imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .vertical)
        self.contentView.addSubview(self.imageView)

        self.titleLabel = QLabel(frame: self.contentView.bounds)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self.titleLabel)

        self.valueLabel = QLabel(frame: self.contentView.bounds)
        self.valueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.valueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
        self.valueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        self.contentView.addSubview(self.valueLabel)
    }

    open override func prepare(data: DataType, animated: Bool) {
        super.prepare(data: data, animated: animated)
        
        if self.currentEdgeInsets != data.edgeInsets || self.currentImageSpacing != data.imageSpacing || self.currentTitleSpacing != data.titleSpacing {
            self.currentEdgeInsets = data.edgeInsets
            self.currentImageSpacing = data.imageSpacing
            self.currentTitleSpacing = data.titleSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.imageView.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.imageView.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.imageView.trailingLayout == self.titleLabel.leadingLayout - data.imageSpacing)
            selfConstraints.append(self.imageView.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.titleLabel.trailingLayout == self.valueLabel.leadingLayout - data.titleSpacing)
            selfConstraints.append(self.titleLabel.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            selfConstraints.append(self.valueLabel.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.valueLabel.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
            selfConstraints.append(self.valueLabel.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        if self.currentImageWidth != data.imageWidth {
            self.currentImageWidth = data.imageWidth

            var imageConstraints: [NSLayoutConstraint] = []
            imageConstraints.append(self.imageView.widthLayout == data.imageWidth)
            self.imageConstraints = imageConstraints
        }
        data.image.apply(target: self.imageView)
        data.title.apply(target: self.titleLabel)
        data.value.apply(target: self.valueLabel)
    }

}
