//
//  Quickly
//

public final class QTextStyle : IQTextStyle {

    public weak var parent: IQTextStyle? {
        set(value) {
            if self._parent !== value {
                if let parent = self._parent {
                    parent.removeChild(self)
                }
                self._parent = value
                if let parent = value {
                    parent.addChild(self)
                }
            }
        }
        get {
            return self._parent
        }
    }
    private weak var _parent: IQTextStyle? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public private(set) var children: [IQTextStyle] = []

    public var font: UIFont? {
        set(value) { self._font = value }
        get {
            if let value = self._font { return value }
            if let parent = self._parent { return parent.font }
            return nil
        }
    }
    private var _font: UIFont? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var color: UIColor? {
        set(value) { self._color = value }
        get {
            if let value = self._color { return value }
            if let parent = self._parent { return parent.color }
            return nil
        }
    }
    private var _color: UIColor? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var backgroundColor: UIColor? {
        set(value) { self._backgroundColor = value }
        get {
            if let value = self._backgroundColor { return value }
            if let parent = self._parent { return parent.backgroundColor }
            return nil
        }
    }
    private var _backgroundColor: UIColor? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var strikeColor: UIColor? {
        set(value) { self._strikeColor = value }
        get {
            if let value = self._strikeColor { return value }
            if let parent = self._parent { return parent.strikeColor }
            return nil
        }
    }
    private var _strikeColor: UIColor? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var strikeWidth: Float? {
        set(value) { self._strikeWidth = value }
        get {
            if let value = self._strikeWidth { return value }
            if let parent = self._parent { return parent.strikeWidth }
            return nil
        }
    }
    private var _strikeWidth: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var strikeThrough: Int? {
        set(value) { self._strikeThrough = value }
        get {
            if let value = self._strikeThrough { return value }
            if let parent = self._parent { return parent.strikeThrough }
            return nil
        }
    }
    private var _strikeThrough: Int? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var underlineColor: UIColor? {
        set(value) { self._underlineColor = value }
        get {
            if let value = self._underlineColor { return value }
            if let parent = self._parent { return parent.underlineColor }
            return nil
        }
    }
    private var _underlineColor: UIColor? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var underlineStyle: NSUnderlineStyle? {
        set(value) { self._underlineStyle = value }
        get {
            if let value = self._underlineStyle { return value }
            if let parent = self._parent { return parent.underlineStyle }
            return nil
        }
    }
    private var _underlineStyle: NSUnderlineStyle? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var shadowOffset: CGSize? {
        set(value) { self._shadowOffset = value }
        get {
            if let value = self._shadowOffset { return value }
            if let parent = self._parent { return parent.shadowOffset }
            return nil
        }
    }
    private var _shadowOffset: CGSize? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var shadowBlurRadius: Float? {
        set(value) { self._shadowBlurRadius = value }
        get {
            if let value = self._shadowBlurRadius { return value }
            if let parent = self._parent { return parent.shadowBlurRadius }
            return nil
        }
    }
    private var _shadowBlurRadius: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var shadowColor: UIColor? {
        set(value) { self._shadowColor = value }
        get {
            if let value = self._shadowColor { return value }
            if let parent = self._parent { return parent.shadowColor }
            return nil
        }
    }
    private var _shadowColor: UIColor? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var ligature: Int? {
        set(value) { self._ligature = value }
        get {
            if let value = self._ligature { return value }
            if let parent = self._parent { return parent.ligature }
            return nil
        }
    }
    private var _ligature: Int? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var kerning: Float? {
        set(value) { self._kerning = value }
        get {
            if let value = self._kerning { return value }
            if let parent = self._parent { return parent.kerning }
            return nil
        }
    }
    private var _kerning: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var baselineOffset: Float? {
        set(value) { self._baselineOffset = value }
        get {
            if let value = self._baselineOffset { return value }
            if let parent = self._parent { return parent.baselineOffset }
            return nil
        }
    }
    private var _baselineOffset: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var obliqueness: Float? {
        set(value) { self._obliqueness = value }
        get {
            if let value = self._obliqueness { return value }
            if let parent = self._parent { return parent.obliqueness }
            return nil
        }
    }
    private var _obliqueness: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var expansion: Float? {
        set(value) { self._expansion = value }
        get {
            if let value = self._expansion { return value }
            if let parent = self._parent { return parent.expansion }
            return nil
        }
    }
    private var _expansion: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var lineSpacing: Float? {
        set(value) { self._lineSpacing = value }
        get {
            if let value = self._lineSpacing { return value }
            if let parent = self._parent { return parent.lineSpacing }
            return nil
        }
    }
    private var _lineSpacing: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var paragraphBetween: Float? {
        set(value) { self._paragraphBetween = value }
        get {
            if let value = self._paragraphBetween { return value }
            if let parent = self._parent { return parent.paragraphBetween }
            return nil
        }
    }
    private var _paragraphBetween: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var alignment: NSTextAlignment? {
        set(value) { self._alignment = value }
        get {
            if let value = self._alignment { return value }
            if let parent = self._parent { return parent.alignment }
            return nil
        }
    }
    private var _alignment: NSTextAlignment? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var firstLineHeadIndent: Float? {
        set(value) { self._firstLineHeadIndent = value }
        get {
            if let value = self._firstLineHeadIndent { return value }
            if let parent = self._parent { return parent.firstLineHeadIndent }
            return nil
        }
    }
    private var _firstLineHeadIndent: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var headIndent: Float? {
        set(value) { self._headIndent = value }
        get {
            if let value = self._headIndent { return value }
            if let parent = self._parent { return parent.headIndent }
            return nil
        }
    }
    private var _headIndent: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var tailIndent: Float? {
        set(value) { self._tailIndent = value }
        get {
            if let value = self._tailIndent { return value }
            if let parent = self._parent { return parent.tailIndent }
            return nil
        }
    }
    private var _tailIndent: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var lineBreakMode: NSLineBreakMode? {
        set(value) { self._lineBreakMode = value }
        get {
            if let value = self._lineBreakMode { return value }
            if let parent = self._parent { return parent.lineBreakMode }
            return nil
        }
    }
    private var _lineBreakMode: NSLineBreakMode? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var minimumLineHeight: Float? {
        set(value) { self._minimumLineHeight = value }
        get {
            if let value = self._minimumLineHeight { return value }
            if let parent = self._parent { return parent.minimumLineHeight }
            return nil
        }
    }
    private var _minimumLineHeight: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var maximumLineHeight: Float? {
        set(value) { self._maximumLineHeight = value }
        get {
            if let value = self._maximumLineHeight { return value }
            if let parent = self._parent { return parent.maximumLineHeight }
            return nil
        }
    }
    private var _maximumLineHeight: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var baseWritingDirection: NSWritingDirection? {
        set(value) { self._baseWritingDirection = value }
        get {
            if let value = self._baseWritingDirection { return value }
            if let parent = self._parent { return parent.baseWritingDirection }
            return nil
        }
    }
    private var _baseWritingDirection: NSWritingDirection? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var lineHeightMultiple: Float? {
        set(value) { self._lineHeightMultiple = value }
        get {
            if let value = self._lineHeightMultiple { return value }
            if let parent = self._parent { return parent.lineHeightMultiple }
            return nil
        }
    }
    private var _lineHeightMultiple: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var paragraphSpacingBefore: Float? {
        set(value) { self._paragraphSpacingBefore = value }
        get {
            if let value = self._paragraphSpacingBefore { return value }
            if let parent = self._parent { return parent.paragraphSpacingBefore }
            return nil
        }
    }
    private var _paragraphSpacingBefore: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var hyphenationFactor: Float? {
        set(value) { self._hyphenationFactor = value }
        get {
            if let value = self._hyphenationFactor { return value }
            if let parent = self._parent { return parent.hyphenationFactor }
            return nil
        }
    }
    private var _hyphenationFactor: Float? {
        didSet { self.setNeedRebuildAttributes() }
    }

    public var attributes: [NSAttributedStringKey: Any] {
        get {
            if self._rebuildAttributes == true {
                self._rebuildAttributes = false
                self._attributes = self.rebuildAttributes()
            }
            return self._attributes
        }
    }
    private var _rebuildAttributes: Bool = true
    private var _attributes: [NSAttributedStringKey: Any] = [:]

    public init() {
    }

    public init(parent: QTextStyle) {
        parent.addChild(self)
    }

    deinit {
        self.removeFromParent()
        self.removeAllChildren()
    }

    public func attributed(_ string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: self.attributes)
    }

    public func mutableAttributed(_ string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string, attributes: self.attributes)
    }

    public func addChild(_ child: IQTextStyle) {
        let index = self.children.index { $0 === child }
        if index == nil {
            self.children.append(child)
            child.parent = self
        }
    }

    public func removeChild(_ child: IQTextStyle) {
        let index = self.children.index(where: { (textStyle) -> Bool in
            return textStyle === child
        })
        if let safeIndex = index {
            self.children.remove(at: safeIndex)
            child.parent = nil
        }
    }

    public func removeFromParent() {
        if let parent = self._parent {
            parent.removeChild(self)
        }
    }

    public func removeAllChildren() {
        let copyChildren = self.children
        self.children.removeAll()
        for child in copyChildren {
            child.parent = nil
        }
    }

    public func setNeedRebuildAttributes() {
        self._rebuildAttributes = true
        for child in self.children {
            child.setNeedRebuildAttributes()
        }
    }

    private func rebuildAttributes() -> [NSAttributedStringKey: Any] {
        var attributes: [NSAttributedStringKey: Any] = [:]
        if let font = self.font {
            attributes[.font] = font
        }
        if let color = self.color {
            attributes[.foregroundColor] = color
        }
        if let backgroundColor = self.backgroundColor {
            attributes[.backgroundColor] = backgroundColor
        }
        if let strikeColor = self.strikeColor {
            attributes[.strokeColor] = strikeColor
        }
        if let strikeColor = self.strikeColor {
            attributes[.strokeColor] = strikeColor
        }
        if let strikeWidth = self.strikeWidth {
            attributes[.strokeWidth] = NSNumber(value: strikeWidth)
        }
        if let strikeThrough = self.strikeThrough {
            attributes[.strikethroughStyle] = NSNumber(value: strikeThrough)
        }
        if let underlineColor = self.underlineColor {
            attributes[.underlineColor] = underlineColor
        }
        if let underlineStyle = self.underlineStyle {
            attributes[.underlineStyle] = NSNumber(value: underlineStyle.rawValue)
        }
        if #available(iOS 6.0, *) {
            let shadow = NSShadow()
            if let shadowColor = self.shadowColor {
                shadow.shadowColor = shadowColor
            }
            if let shadowOffset = self.shadowOffset {
                shadow.shadowOffset = shadowOffset
            }
            if let shadowBlurRadius = self.shadowBlurRadius {
                shadow.shadowBlurRadius = CGFloat(shadowBlurRadius)
            }
            attributes[.shadow] = shadow
        }
        if let ligature = self.ligature {
            attributes[.ligature] = NSNumber(value: ligature)
        }
        if let kerning = self.kerning {
            attributes[.kern] = NSNumber(value: kerning)
        }
        if let baselineOffset = self.baselineOffset {
            attributes[.baselineOffset] = NSNumber(value: baselineOffset)
        }
        if let obliqueness = self.obliqueness {
            attributes[.obliqueness] = NSNumber(value: obliqueness)
        }
        if let expansion = self.expansion {
            attributes[.expansion] = NSNumber(value: expansion)
        }
        let paragraphStyle = NSMutableParagraphStyle()
        if let lineSpacing = self.lineSpacing {
            paragraphStyle.lineSpacing = CGFloat(lineSpacing)
        }
        if let paragraphBetween = self.paragraphBetween {
            paragraphStyle.lineSpacing = CGFloat(paragraphBetween)
        }
        if let alignment = self.alignment {
            paragraphStyle.alignment = alignment
        }
        if let firstLineHeadIndent = self.firstLineHeadIndent {
            paragraphStyle.firstLineHeadIndent = CGFloat(firstLineHeadIndent)
        }
        if let headIndent = self.headIndent {
            paragraphStyle.headIndent = CGFloat(headIndent)
        }
        if let tailIndent = self.tailIndent {
            paragraphStyle.tailIndent = CGFloat(tailIndent)
        }
        if let lineBreakMode = self.lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }
        if let minimumLineHeight = self.minimumLineHeight {
            paragraphStyle.minimumLineHeight = CGFloat(minimumLineHeight)
        }
        if let maximumLineHeight = self.maximumLineHeight {
            paragraphStyle.maximumLineHeight = CGFloat(maximumLineHeight)
        }
        if let baseWritingDirection = self.baseWritingDirection {
            paragraphStyle.baseWritingDirection = baseWritingDirection
        }
        if let lineHeightMultiple = self.lineHeightMultiple {
            paragraphStyle.lineHeightMultiple = CGFloat(lineHeightMultiple)
        }
        if let paragraphSpacingBefore = self.paragraphSpacingBefore {
            paragraphStyle.paragraphSpacingBefore = CGFloat(paragraphSpacingBefore)
        }
        if let hyphenationFactor = self.hyphenationFactor {
            paragraphStyle.hyphenationFactor = hyphenationFactor
        }
        attributes[.paragraphStyle] = paragraphStyle
        return attributes
    }

}
