//
//  Quickly
//

open class QPlaceholderStyleSheet : IQStyleSheet {
    
    public var bubble: QDisplayStyleSheet
    public var alignment: QPlaceholderView.Alignment
    
    public init(
        color: UIColor? = nil,
        cornerRadius: QViewCornerRadius = .none,
        shadow: QViewShadow? = nil,
        alignment: QPlaceholderView.Alignment = .left(width: 0.5)
    ) {
        self.bubble = QDisplayStyleSheet(
            backgroundColor: color,
            cornerRadius: cornerRadius,
            shadow: shadow
        )
        self.alignment = alignment
    }
    
    public init(_ styleSheet: QPlaceholderStyleSheet) {
        self.bubble = styleSheet.bubble
        self.alignment = styleSheet.alignment
    }
    
}

open class QPlaceholderView : QView {
    
    public private(set) lazy var bubbleView: QDisplayView = {
        let view = QDisplayView(frame: self.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        return view
    }()
    public var alignment: Alignment = .left(width: 0.5) {
        didSet { self.setNeedsUpdateConstraints() }
    }
    
    private var _constraints: [NSLayoutConstraint] = [] {
        willSet { self.removeConstraints(self._constraints) }
        didSet { self.addConstraints(self._constraints) }
    }
    
    open override func setup() {
        super.setup()
        
        self.backgroundColor = UIColor.clear
    }
    
    open override func updateConstraints() {
        super.updateConstraints()
        
        switch self.alignment {
        case .fill:
            self._constraints = [
                self.bubbleView.topLayout == self.topLayout,
                self.bubbleView.bottomLayout == self.bottomLayout,
                self.bubbleView.leadingLayout == self.leadingLayout,
                self.bubbleView.trailingLayout == self.trailingLayout
            ]
        case .left(let width):
            self._constraints = [
                self.bubbleView.topLayout == self.topLayout,
                self.bubbleView.bottomLayout == self.bottomLayout,
                self.bubbleView.leadingLayout == self.leadingLayout,
                self.bubbleView.widthLayout == (self.widthLayout * width)
            ]
        case .center(let width):
            self._constraints = [
                self.bubbleView.topLayout == self.topLayout,
                self.bubbleView.bottomLayout == self.bottomLayout,
                self.bubbleView.centerXLayout == self.centerXLayout,
                self.bubbleView.widthLayout == (self.widthLayout * width)
            ]
        case .right(let width):
            self._constraints = [
                self.bubbleView.topLayout == self.topLayout,
                self.bubbleView.bottomLayout == self.bottomLayout,
                self.bubbleView.trailingLayout == self.trailingLayout,
                self.bubbleView.widthLayout == (self.widthLayout * width)
            ]
        }
    }
    
    public func apply(_ styleSheet: QPlaceholderStyleSheet) {
        self.bubbleView.apply(styleSheet.bubble)
        self.alignment = styleSheet.alignment
    }
    
}

extension QPlaceholderView {
    
    public enum Alignment {
        case fill
        case left(width: CGFloat)
        case center(width: CGFloat)
        case right(width: CGFloat)
    }
    
}
