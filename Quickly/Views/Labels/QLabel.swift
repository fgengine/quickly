//
//  Quickly
//

open class QLabelStyleSheet : QDisplayViewStyleSheet< QLabel > {

    public var text: IQText
    public var verticalAlignment: QViewVerticalAlignment
    public var padding: CGFloat
    public var lineBreakMode: NSLineBreakMode
    public var numberOfLines: Int

    public init(
        text: IQText,
        verticalAlignment: QViewVerticalAlignment = .center,
        padding: CGFloat = 0,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        numberOfLines: Int = 0,
        backgroundColor: UIColor? = UIColor.clear
    ) {
        self.text = text
        self.verticalAlignment = verticalAlignment
        self.padding = padding
        self.lineBreakMode = lineBreakMode
        self.numberOfLines = numberOfLines
        
        super.init(backgroundColor: backgroundColor)
    }

    public init(_ styleSheet: QLabelStyleSheet) {
        self.text = styleSheet.text
        self.verticalAlignment = styleSheet.verticalAlignment
        self.padding = styleSheet.padding
        self.lineBreakMode = styleSheet.lineBreakMode
        self.numberOfLines = styleSheet.numberOfLines

        super.init(styleSheet)
    }

    public override func apply(target: QLabel) {
        super.apply(target: target)

        target.text = self.text
        target.verticalAlignment = self.verticalAlignment
        target.padding = self.padding
        target.lineBreakMode = self.lineBreakMode
        target.numberOfLines = self.numberOfLines
    }

}

open class QLabel : QDisplayView {

    public var verticalAlignment: QViewVerticalAlignment = .center {
        didSet { self.setNeedsDisplay() }
    }
    public var padding: CGFloat {
        set(value) {
            if self.textContainer.lineFragmentPadding != value {
                self.textContainer.lineFragmentPadding = value
                self.invalidateIntrinsicContentSize()
                self.setNeedsDisplay()
            }
        }
        get { return self.textContainer.lineFragmentPadding }
    }
    public var numberOfLines: Int {
        set(value) {
            if self.textContainer.maximumNumberOfLines != value {
                self.textContainer.maximumNumberOfLines = value
                self.invalidateIntrinsicContentSize()
                self.setNeedsDisplay()
            }
        }
        get { return self.textContainer.maximumNumberOfLines }
    }
    public var lineBreakMode: NSLineBreakMode {
        set(value) {
            if self.textContainer.lineBreakMode != value {
                self.textContainer.lineBreakMode = value
                self.invalidateIntrinsicContentSize()
                self.setNeedsDisplay()
            }
        }
        get { return self.textContainer.lineBreakMode }
    }
    public var text: IQText? {
        didSet {
            self._updateTextStorage()
            self.invalidateIntrinsicContentSize()
            self.setNeedsDisplay()
        }
    }
    public var preferredMaxLayoutWidth: CGFloat = 0 {
        didSet(oldValue) {
            if self.preferredMaxLayoutWidth != oldValue {
                self.invalidateIntrinsicContentSize()
                self.setNeedsDisplay()
            }
        }
    }
    open override var frame: CGRect {
        didSet(oldValue) {
            if self.frame != oldValue {
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    open override var bounds: CGRect {
        didSet(oldValue) {
            if self.bounds != oldValue {
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    open override var intrinsicContentSize: CGSize {
        get {
            if self.cacheIntrinsicContentSize == nil {
                self.cacheIntrinsicContentSize = self.sizeThatFits(CGSize(
                    width: self._currentPreferredMaxLayoutWidth(),
                    height: CGFloat.greatestFiniteMagnitude
                ))
            }
            return self.cacheIntrinsicContentSize!
        }
    }
    open override var forFirstBaselineLayout: UIView {
        get {
            if self.firstBaselineView == nil {
                self.firstBaselineView = UIView(frame: self.bounds)
                self.firstBaselineView.backgroundColor = nil
                self.addSubview(self.firstBaselineView)
            }
            return self.firstBaselineView

        }
    }
    open override var forLastBaselineLayout: UIView {
        get {
            if self.lastBaselineView == nil {
                self.lastBaselineView = UIView(frame: self.bounds)
                self.lastBaselineView.backgroundColor = nil
                self.addSubview(self.lastBaselineView)
            }
            return self.lastBaselineView!
        }
    }

    internal let textContainer: NSTextContainer = NSTextContainer()
    internal let layoutManager: NSLayoutManager = NSLayoutManager()
    internal let textStorage: NSTextStorage = NSTextStorage()
    internal var firstBaselineView: UIView!
    internal var lastBaselineView: UIView!

    private var cacheIntrinsicContentSize: CGSize?
    private var layoutEngine: AnyObject? {
        let objcMethodName = "nsli_layoutEngine"
        let objcSelector = Selector(objcMethodName)
        typealias targetCFunction = @convention(c) (AnyObject, Selector) -> AnyObject
        let target = class_getMethodImplementation(type(of: self).self, objcSelector)
        let casted = unsafeBitCast(target, to: targetCFunction.self)
        return casted(self, objcSelector)
    }
    private var compatibleBounds: CGRect? {
        let objcMethodName = "_nsis_compatibleBoundsInEngine:"
        let objcSelector = Selector(objcMethodName)
        typealias targetCFunction = @convention(c) (AnyObject, Selector, Any) -> CGRect
        let target = class_getMethodImplementation(type(of: self).self, objcSelector)
        let casted = unsafeBitCast(target, to: targetCFunction.self)
        if let layoutEngine = self.layoutEngine {
            return casted(self, objcSelector, layoutEngine)
        }
        return nil
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        self.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
    }

    public convenience init(frame: CGRect, styleSheet: QLabelStyleSheet) {
        self.init(frame: frame)
        styleSheet.apply(target: self)
    }

    public convenience init(styleSheet: QLabelStyleSheet) {
        self.init(frame: CGRect.zero)
        styleSheet.apply(target: self)
        self.sizeToFit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    open override func setup() {
        super.setup()

        self.backgroundColor = UIColor.clear
        self.contentMode = .redraw

        self.textContainer.lineBreakMode = .byTruncatingTail
        self.textContainer.lineFragmentPadding = 0
        self.textContainer.maximumNumberOfLines = 1

        self.layoutManager.addTextContainer(self.textContainer)

        self.textStorage.addLayoutManager(self.layoutManager)
    }

    public func characterIndex(point: CGPoint) -> String.Index? {
        let viewRect = self.bounds
        let textSize = self.layoutManager.usedRect(for: self.textContainer).integral.size
        let textOffset = self._alignmentPoint(size: viewRect.size, textSize: textSize)
        let textRect = CGRect(x: textOffset.x, y: textOffset.y, width: textSize.width, height: textSize.height)
        if textRect.contains(point) == true {
            let location = CGPoint(
                x: point.x - textOffset.x,
                y: point.y - textOffset.y
            )
            let index = self.layoutManager.characterIndex(
                for: location,
                in: self.textContainer,
                fractionOfDistanceBetweenInsertionPoints: nil
            )
            let string = self.textStorage.string
            return string.index(string.startIndex, offsetBy: index)
        }
        return nil
    }

    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        self.cacheIntrinsicContentSize = nil
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        self.textContainer.size = self.bounds.integral.size

        if self.firstBaselineView != nil || self.lastBaselineView != nil {
            let viewRect = self.bounds.integral
            let textSize = self.layoutManager.usedRect(for: self.textContainer).integral.size
            let textOffset = self._alignmentPoint(size: viewRect.size, textSize: textSize)
            let length = self.textStorage.length
            if length > 0 {
                var firstLineRange = NSRange()
                let firstLineRect = self.layoutManager.lineFragmentRect(forGlyphAt: 0, effectiveRange: &firstLineRange)
                let firstFontInfo = self.textStorage.fontInfo(range: firstLineRange)
                var lastFontInfo = QFontInfo()
                var lastLineRect = CGRect.zero
                if firstLineRange.contains(length - 1) == false {
                    var lastLineRange = NSRange()
                    lastLineRect = self.layoutManager.lineFragmentRect(forGlyphAt: length - 1, effectiveRange: &lastLineRange)
                    lastFontInfo = self.textStorage.fontInfo(range: lastLineRange)
                } else {
                    lastFontInfo = firstFontInfo
                    lastLineRect = firstLineRect
                }
                if self.firstBaselineView != nil {
                    self.firstBaselineView.frame = CGRect(
                        x: 0,
                        y: textOffset.y + firstLineRect.origin.y + firstFontInfo.ascender,
                        width: viewRect.width,
                        height: 1 / UIScreen.main.scale
                    )
                }
                if self.lastBaselineView != nil {
                    self.lastBaselineView.frame = CGRect(
                        x: 0,
                        y: textOffset.y + lastLineRect.origin.y + lastFontInfo.ascender,
                        width: viewRect.width,
                        height: 1 / UIScreen.main.scale
                    )
                }
            } else {
                if self.firstBaselineView != nil {
                    self.firstBaselineView.frame = CGRect(
                        x: 0,
                        y: textOffset.y,
                        width: viewRect.width,
                        height: 1 / UIScreen.main.scale
                    )
                }
                if self.lastBaselineView != nil {
                    self.lastBaselineView.frame = CGRect(
                        x: 0,
                        y: textOffset.y + textSize.height,
                        width: viewRect.width,
                        height: 1 / UIScreen.main.scale
                    )
                }
            }
        }
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        let viewRect = self.bounds.integral
        let textSize = self.layoutManager.usedRect(for: self.textContainer).integral.size
        let textOffset = self._alignmentPoint(size: viewRect.size, textSize: textSize)
        let textRange = self.layoutManager.glyphRange(for: self.textContainer)
        self.layoutManager.drawBackground(forGlyphRange: textRange, at: textOffset)
        self.layoutManager.drawGlyphs(forGlyphRange: textRange, at: textOffset)
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if self.textStorage.length < 1 {
            return CGSize.zero
        }
        let textContainer = NSTextContainer(size: size)
        textContainer.lineBreakMode = self.textContainer.lineBreakMode
        textContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        let textStorage: NSTextStorage = NSTextStorage(attributedString: self.textStorage)
        textStorage.addLayoutManager(layoutManager)
        let frame = layoutManager.usedRect(for: textContainer)
        return frame.integral.size
    }

    open override func sizeToFit() {
        super.sizeToFit()

        self.frame.size = self.sizeThatFits(CGSize(
            width: self._currentPreferredMaxLayoutWidth(),
            height: CGFloat.greatestFiniteMagnitude
        ))
    }

    internal func _currentPreferredMaxLayoutWidth() -> CGFloat {
        let maxLayoutWidth = self.preferredMaxLayoutWidth
        if maxLayoutWidth > CGFloat.leastNonzeroMagnitude {
            return maxLayoutWidth
        }
        if let compatibleBounds = self.compatibleBounds {
            return compatibleBounds.width
        }
        return self.bounds.width
    }

    internal func _updateTextStorage() {
        if let text = self.text {
            self.textStorage.setAttributedString(text.attributed)
        } else {
            self.textStorage.deleteAllCharacters()
        }
    }
    
    @objc
    private func _needsDoubleUpdateConstraintsPass() -> Bool {
        return true
    }

    private func _alignmentPoint(size: CGSize, textSize: CGSize) -> CGPoint {
        var y = size.height - textSize.height
        switch self.verticalAlignment {
        case .top: y = 0
        case .center: y = max(y / 2, 0)
        case .bottom: y = max(y, 0)
        }
        return CGPoint(x: 0, y: y)
    }

}
