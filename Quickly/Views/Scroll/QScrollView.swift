//
//  Quickly
//

public enum QScrollViewDirection {
    case vertical
    case horizontal
    case stretch
}

open class QScrollView : UIScrollView, IQView {

    public var direction: QScrollViewDirection {
        didSet { self.setNeedsUpdateConstraints() }
    }

    public private(set) var contentView: UIView!

    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self.selfConstraints) }
        didSet { self.addConstraints(self.selfConstraints) }
    }
    private var contentConstraints: [NSLayoutConstraint] = [] {
        willSet { self.contentView.removeConstraints(self.contentConstraints) }
        didSet { self.contentView.addConstraints(self.contentConstraints) }
    }

    public init(frame: CGRect, direction: QScrollViewDirection) {
        self.direction = direction
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder: NSCoder) {
        self.direction = .vertical
        super.init(coder: coder)
        self.setup()
    }

    open func setup() {
        self.backgroundColor = UIColor.clear

        self.contentView = UIView(frame: self.bounds)
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(self.contentView)
    }

    open override func updateConstraints() {
        super.updateConstraints()
        
        var selfConstraints: [NSLayoutConstraint] = []
        selfConstraints.append(self.topLayout == self.contentView.topLayout)
        selfConstraints.append(self.leadingLayout == self.contentView.leadingLayout)
        selfConstraints.append(self.trailingLayout == self.contentView.trailingLayout)
        selfConstraints.append(self.bottomLayout == self.contentView.bottomLayout)
        self.selfConstraints = selfConstraints

        var contentConstraints: [NSLayoutConstraint] = []
        switch self.direction {
        case .stretch:
            contentConstraints.append(self.widthLayout == self.contentView.widthLayout)
            contentConstraints.append(self.heightLayout == self.contentView.heightLayout)
        case .vertical:
            contentConstraints.append(self.widthLayout == self.contentView.widthLayout)
        case .horizontal:
            contentConstraints.append(self.heightLayout == self.contentView.heightLayout)
        }
        self.contentConstraints = contentConstraints
    }

}
