//
//  Quickly
//

open class QLabelStyleSheet : QDisplayViewStyleSheet< QLabel > {

    public var text: IQText
    public var alignment: NSTextAlignment
    public var lineBreakMode: NSLineBreakMode
    public var numberOfLines: Int

    public init(
        text: IQText,
        alignment: NSTextAlignment = .left,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        numberOfLines: Int = 0,
        backgroundColor: UIColor? = nil,
        cornerRadius: QViewCornerRadius = .none,
        border: QViewBorder = .none,
        shadow: QViewShadow? = nil
    ) {
        self.text = text
        self.alignment = alignment
        self.lineBreakMode = lineBreakMode
        self.numberOfLines = numberOfLines
        
        super.init(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            border: border,
            shadow: shadow
        )
    }

    public init(_ styleSheet: QLabelStyleSheet) {
        self.text = styleSheet.text
        self.alignment = styleSheet.alignment
        self.lineBreakMode = styleSheet.lineBreakMode
        self.numberOfLines = styleSheet.numberOfLines

        super.init(styleSheet)
    }

    public override func apply(_ target: QLabel) {
        super.apply(target)

        target.text = self.text
        target.alignment = self.alignment
        target.lineBreakMode = self.lineBreakMode
        target.numberOfLines = self.numberOfLines
    }

}

open class QLabel : QDisplayView {
    
    public var alignment: NSTextAlignment {
        set(value) { self.label.textAlignment = value }
        get { return self.label.textAlignment }
    }
    public var lineBreakMode: NSLineBreakMode {
        set(value) { self.label.lineBreakMode = value }
        get { return self.label.lineBreakMode }
    }
    public var numberOfLines: Int {
        set(value) { self.label.numberOfLines = value }
        get { return self.label.numberOfLines }
    }
    public var text: IQText? {
        didSet(oldValue) {
            if self.text !== oldValue {
                if let text = self.text {
                    if let attributed = text.attributed {
                        self.label.text = nil
                        self.label.attributedText = attributed
                    } else if let font = text.font, let color = text.color {
                        self.label.attributedText = nil
                        self.label.text = text.string
                        self.label.font = font
                        self.label.textColor = color
                    }
                } else {
                    self.label.text = nil
                    self.label.attributedText = nil
                }
            }
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        get { return self.label.intrinsicContentSize }
    }
    open override var forFirstBaselineLayout: UIView {
        get { return self.label.forFirstBaselineLayout }
    }
    open override var forLastBaselineLayout: UIView {
        get { return self.label.forLastBaselineLayout }
    }

    private lazy var label: UILabel = {
        let view = UILabel(frame: self.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        self.addSubview(view)
        self.addConstraints([
            view.topLayout == self.topLayout,
            view.leftLayout == self.leftLayout,
            view.rightLayout == self.rightLayout,
            view.bottomLayout == self.bottomLayout
        ])
        return view
    }()
    
    public required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setContentHuggingPriority(
            horizontal: UILayoutPriority(rawValue: 251),
            vertical: UILayoutPriority(rawValue: 251)
        )
    }

    public convenience init(frame: CGRect, styleSheet: QLabelStyleSheet) {
        self.init(frame: frame)
        styleSheet.apply(self)
    }

    public convenience init(styleSheet: QLabelStyleSheet) {
        self.init(frame: CGRect.zero)
        styleSheet.apply(self)
        self.sizeToFit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear
        self.contentMode = .center
    }

    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        self.label.invalidateIntrinsicContentSize()
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.label.sizeThatFits(size)
    }

}
