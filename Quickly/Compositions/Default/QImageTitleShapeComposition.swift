//
//  Quickly
//

open class QImageTitleShapeCompositionData : QCompositionData {

    public var image: QImageViewStyleSheet
    public var imageWidth: CGFloat
    public var imageSpacing: CGFloat

    public var title: QLabelStyleSheet

    public var shape: IQShapeModel
    public var shapeWidth: CGFloat
    public var shapeSpacing: CGFloat

    public init(
        image: QImageViewStyleSheet,
        title: QLabelStyleSheet,
        shape: IQShapeModel
    ) {
        self.image = image
        self.imageWidth = 96
        self.imageSpacing = 0
        self.title = title
        self.shape = shape
        self.shapeWidth = 16
        self.shapeSpacing = 0
        super.init()
    }

}

public class QImageTitleShapeComposition< DataType: QImageTitleShapeCompositionData >: QComposition< DataType > {

    public private(set) var imageView: QImageView!
    public private(set) var titleLabel: QLabel!
    public private(set) var shapeView: QShapeView!

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
        willSet { self.imageView.removeConstraints(self.imageConstraints) }
        didSet { self.imageView.addConstraints(self.imageConstraints) }
    }
    private var shapeConstraints: [NSLayoutConstraint] = [] {
        willSet { self.shapeView.removeConstraints(self.shapeConstraints) }
        didSet { self.shapeView.addConstraints(self.shapeConstraints) }
    }

    open override class func size(data: DataType?, size: CGSize) -> CGSize {
        guard let data = data else { return CGSize.zero }
        let availableWidth = size.width - (data.edgeInsets.left + data.edgeInsets.right)
        let imageSize = data.image.source.size(CGSize(width: data.imageWidth, height: availableWidth))
        let titleTextSize = data.title.text.size(width: availableWidth - (data.imageWidth + data.imageSpacing + data.shapeWidth + data.shapeSpacing))
        return CGSize(
            width: size.width,
            height: data.edgeInsets.top + max(imageSize.height, titleTextSize.height, data.shape.size.height) + data.edgeInsets.bottom
        )
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

        self.shapeView = QShapeView(frame: self.contentView.bounds)
        self.shapeView.translatesAutoresizingMaskIntoConstraints = false
        self.shapeView.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .horizontal)
        self.shapeView.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .vertical)
        self.contentView.addSubview(self.shapeView)
    }

    open override func prepare(data: DataType, animated: Bool) {
        if self.currentEdgeInsets != data.edgeInsets || self.currentImageSpacing != data.imageSpacing || self.currentShapeSpacing != data.shapeSpacing {
            self.currentEdgeInsets = data.edgeInsets
            self.currentImageSpacing = data.imageSpacing
            self.currentShapeSpacing = data.shapeSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.imageView.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.imageView.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.imageView.trailingLayout == self.titleLabel.leadingLayout - data.imageSpacing)
            selfConstraints.append(self.imageView.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.titleLabel.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            selfConstraints.append(self.shapeView.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.shapeView.leadingLayout == self.titleLabel.trailingLayout + data.shapeSpacing)
            selfConstraints.append(self.shapeView.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
            selfConstraints.append(self.shapeView.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        if self.currentImageWidth != data.imageWidth {
            self.currentImageWidth = data.imageWidth

            var imageConstraints: [NSLayoutConstraint] = []
            imageConstraints.append(self.imageView.widthLayout == data.imageWidth)
            self.imageConstraints = imageConstraints
        }
        if self.currentShapeWidth != data.shapeWidth {
            self.currentShapeWidth = data.shapeWidth

            var shapeConstraints: [NSLayoutConstraint] = []
            shapeConstraints.append(self.shapeView.widthLayout == data.shapeWidth)
            self.shapeConstraints = shapeConstraints
        }
        data.image.apply(target: self.imageView)
        data.title.apply(target: self.titleLabel)
        self.shapeView.model = data.shape
    }

}
