//
//  Quickly
//

public enum QPlaceholderViewAlignment {
    case fill
    case left(width: CGFloat)
    case center(width: CGFloat)
    case right(width: CGFloat)
}

open class QPlaceholderViewStyleSheet : IQStyleSheet {
    
    public var bubble: QDisplayViewStyleSheet< QDisplayView >
    public var alignment: QPlaceholderViewAlignment
    
    public init(
        color: UIColor? = nil,
        cornerRadius: QViewCornerRadius = .none,
        shadow: QViewShadow? = nil,
        alignment: QPlaceholderViewAlignment = .left(width: 0.5)
    ) {
        self.bubble = QDisplayViewStyleSheet< QDisplayView >(
            backgroundColor: color,
            cornerRadius: cornerRadius,
            shadow: shadow
        )
        self.alignment = alignment
    }
    
    public init(_ styleSheet: QPlaceholderViewStyleSheet) {
        self.bubble = styleSheet.bubble
        self.alignment = styleSheet.alignment
    }
    
    public func apply(_ target: QPlaceholderView) {
        self.bubble.apply(target.bubble)
        target.alignment = self.alignment
    }
    
}

open class QPlaceholderView : QView {
    
    public private(set) lazy var bubble: QDisplayView = {
        let view = QDisplayView(frame: self.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        return view
    }()
    public var alignment: QPlaceholderViewAlignment = .left(width: 0.5) {
        didSet { self.setNeedsUpdateConstraints() }
    }
    
    private var selfConstraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self.selfConstraints) }
        didSet { self.addConstraints(self.selfConstraints) }
    }
    
    open override func setup() {
        super.setup()
        
        self.backgroundColor = UIColor.clear
    }
    
    open override func updateConstraints() {
        super.updateConstraints()
        
        switch self.alignment {
        case .fill:
            self.selfConstraints = [
                self.bubble.topLayout == self.topLayout,
                self.bubble.bottomLayout == self.bottomLayout,
                self.bubble.leadingLayout == self.leadingLayout,
                self.bubble.trailingLayout == self.trailingLayout
            ]
        case .left(let width):
            self.selfConstraints = [
                self.bubble.topLayout == self.topLayout,
                self.bubble.bottomLayout == self.bottomLayout,
                self.bubble.leadingLayout == self.leadingLayout,
                self.bubble.widthLayout == (self.widthLayout * width)
            ]
        case .center(let width):
            self.selfConstraints = [
                self.bubble.topLayout == self.topLayout,
                self.bubble.bottomLayout == self.bottomLayout,
                self.bubble.centerXLayout == self.centerXLayout,
                self.bubble.widthLayout == (self.widthLayout * width)
            ]
        case .right(let width):
            self.selfConstraints = [
                self.bubble.topLayout == self.topLayout,
                self.bubble.bottomLayout == self.bottomLayout,
                self.bubble.trailingLayout == self.trailingLayout,
                self.bubble.widthLayout == (self.widthLayout * width)
            ]
        }
    }
    
}
