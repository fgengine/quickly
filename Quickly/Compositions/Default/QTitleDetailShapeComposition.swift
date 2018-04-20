//
//  Quickly
//

open class QTitleDetailShapeCompositionData : QCompositionData {

    public var title: QLabelStyleSheet
    public var titleSpacing: CGFloat

    public var detail: QLabelStyleSheet

    public var shape: IQShapeModel
    public var shapeWidth: CGFloat
    public var shapeSpacing: CGFloat

    public init(
        title: QLabelStyleSheet,
        detail: QLabelStyleSheet,
        shape: IQShapeModel
    ) {
        self.title = title
        self.titleSpacing = 4
        self.detail = detail
        self.shape = shape
        self.shapeWidth = 16
        self.shapeSpacing = 8
        super.init()
    }

}

public class QTitleDetailShapeComposition< DataType: QTitleDetailShapeCompositionData >: QComposition< DataType > {

    public private(set) var titleLabel: QLabel!
    public private(set) var detailLabel: QLabel!
    public private(set) var shapeView: QShapeView!

    private var currentEdgeInsets: UIEdgeInsets?
    private var currentTitleSpacing: CGFloat?
    private var currentShapeWidth: CGFloat?
    private var currentShapeSpacing: CGFloat?

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.selfConstraints) }
        didSet { self.contentView.addConstraints(self.selfConstraints) }
    }
    private var shapeConstraints: [NSLayoutConstraint] = [] {
        willSet { self.shapeView.removeConstraints(self.shapeConstraints) }
        didSet { self.shapeView.addConstraints(self.shapeConstraints) }
    }

    open override class func size(data: DataType?, size: CGSize) -> CGSize {
        guard let data = data else { return CGSize.zero }
        let availableWidth = size.width - (data.edgeInsets.left + data.edgeInsets.right)
        let titleTextSize = data.title.text.size(width: availableWidth - (data.shapeWidth + data.shapeSpacing))
        let detailTextSize = data.detail.text.size(width: availableWidth - (data.shapeWidth + data.shapeSpacing))
        return CGSize(
            width: size.width,
            height: data.edgeInsets.top + max(titleTextSize.height + data.titleSpacing + detailTextSize.height, data.shape.size.height) + data.edgeInsets.bottom
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

        self.shapeView = QShapeView(frame: self.contentView.bounds)
        self.shapeView.translatesAutoresizingMaskIntoConstraints = false
        self.shapeView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.shapeView.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        self.contentView.addSubview(self.shapeView)
}

    open override func prepare(data: DataType, animated: Bool) {
        if self.currentEdgeInsets != data.edgeInsets || self.currentTitleSpacing != data.titleSpacing || self.currentShapeSpacing != data.shapeSpacing {
            self.currentEdgeInsets = data.edgeInsets
            self.currentTitleSpacing = data.titleSpacing
            self.currentShapeSpacing = data.shapeSpacing

            var selfConstraints: [NSLayoutConstraint] = []
            selfConstraints.append(self.titleLabel.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.titleLabel.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.titleLabel.bottomLayout == self.detailLabel.topLayout - data.titleSpacing)
            selfConstraints.append(self.detailLabel.leadingLayout == self.contentView.leadingLayout + data.edgeInsets.left)
            selfConstraints.append(self.detailLabel.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            selfConstraints.append(self.shapeView.topLayout == self.contentView.topLayout + data.edgeInsets.top)
            selfConstraints.append(self.shapeView.leadingLayout == self.titleLabel.trailingLayout + data.shapeSpacing)
            selfConstraints.append(self.shapeView.leadingLayout == self.detailLabel.trailingLayout + data.shapeSpacing)
            selfConstraints.append(self.shapeView.trailingLayout == self.contentView.trailingLayout - data.edgeInsets.right)
            selfConstraints.append(self.shapeView.bottomLayout == self.contentView.bottomLayout - data.edgeInsets.bottom)
            self.selfConstraints = selfConstraints
        }
        if self.currentShapeWidth != data.shapeWidth {
            self.currentShapeWidth = data.shapeWidth

            var shapeConstraints: [NSLayoutConstraint] = []
            shapeConstraints.append(self.shapeView.widthLayout == data.shapeWidth)
            self.shapeConstraints = shapeConstraints
        }
        data.title.apply(target: self.titleLabel)
        data.detail.apply(target: self.detailLabel)
        self.shapeView.model = data.shape
    }

}
