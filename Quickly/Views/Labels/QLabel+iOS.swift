//
//  Quickly
//

#if os(iOS)

    public class QLabelStyleSheet : QDisplayViewStyleSheet< QLabel > {

        public var text: IQText
        public var verticalAlignment: QViewVerticalAlignment
        public var horizontalAlignment: QViewHorizontalAlignment
        public var padding: CGFloat = 0
        public var numberOfLines: Int = 0
        public var lineBreakMode: NSLineBreakMode

        public init(
            text: IQText,
            verticalAlignment: QViewVerticalAlignment,
            horizontalAlignment: QViewHorizontalAlignment,
            lineBreakMode: NSLineBreakMode
        ) {
            self.text = text
            self.verticalAlignment = verticalAlignment
            self.horizontalAlignment = horizontalAlignment
            self.padding = 0
            self.numberOfLines = 0
            self.lineBreakMode = lineBreakMode

            super.init()
        }

        public convenience init(text: IQText) {
            self.init(
                text: text,
                verticalAlignment: .center,
                horizontalAlignment: .left,
                lineBreakMode: .byWordWrapping
            )
        }

        public override func apply(target: QLabel) {
            super.apply(target: target)

            target.text = self.text
            target.verticalAlignment = self.verticalAlignment
            target.horizontalAlignment = self.horizontalAlignment
            target.padding = self.padding
            target.numberOfLines = self.numberOfLines
            target.lineBreakMode = self.lineBreakMode
        }

    }

    open class QLabel : QDisplayView {

        public var verticalAlignment: QViewVerticalAlignment = .center {
            didSet { self.setNeedsDisplay() }
        }
        public var horizontalAlignment: QViewHorizontalAlignment = .left {
            didSet { self.setNeedsDisplay() }
        }
        public var padding: CGFloat {
            set {
                self.textContainer.lineFragmentPadding = newValue
                self.invalidateIntrinsicContentSize()
                self.setNeedsDisplay()
            }
            get { return self.textContainer.lineFragmentPadding }
        }
        public var numberOfLines: Int {
            set(value) {
                self.textContainer.maximumNumberOfLines = value
                self.invalidateIntrinsicContentSize()
                self.setNeedsDisplay()
            }
            get { return self.textContainer.maximumNumberOfLines }
        }
        public var lineBreakMode: NSLineBreakMode {
            set {
                self.textContainer.lineBreakMode = newValue
                self.invalidateIntrinsicContentSize()
                self.setNeedsDisplay()
            }
            get { return self.textContainer.lineBreakMode }
        }
        public var text: IQText? {
            didSet {
                self.updateTextStorage()
                self.invalidateIntrinsicContentSize()
                self.setNeedsDisplay()
            }
        }
        public var preferredMaxLayoutWidth: CGFloat = 0 {
            didSet {
                self.invalidateIntrinsicContentSize()
                self.setNeedsDisplay()
            }
        }
        open override var frame: CGRect {
            didSet { self.invalidateIntrinsicContentSize() }
        }
        open override var bounds: CGRect {
            didSet { self.invalidateIntrinsicContentSize() }
        }
        open override var intrinsicContentSize: CGSize {
            get {
                return self.sizeThatFits(CGSize(
                    width: self.currentPreferredMaxLayoutWidth(),
                    height: CGFloat.greatestFiniteMagnitude
                ))
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

        public override init(frame: CGRect) {
            super.init(frame: frame)
            self.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
            self.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        }

        public required init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        open override func setup() {
            super.setup()

            self.backgroundColor = UIColor.clear
            self.contentMode = .redraw
            self.isOpaque = false

            self.textContainer.lineBreakMode = .byTruncatingTail
            self.textContainer.lineFragmentPadding = 0
            self.textContainer.maximumNumberOfLines = 1

            self.layoutManager.addTextContainer(self.textContainer)

            self.textStorage.addLayoutManager(self.layoutManager)
        }

        #if TARGET_INTERFACE_BUILDER

        open override func prepareForInterfaceBuilder() {
            self.textStorage.setAttributedString(NSAttributedString(string: "QLabel"))
        }

        #endif

        public func characterIndex(point: CGPoint) -> String.Index? {
            let viewRect = self.bounds
            let textSize = self.layoutManager.usedRect(for: self.textContainer).integral.size
            let textOffset = self.alignmentPoint(size: viewRect.size, textSize: textSize)
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

        open override func layoutSubviews() {
            super.layoutSubviews()

            self.textContainer.size = self.bounds.integral.size

            if self.firstBaselineView != nil || self.lastBaselineView != nil {
                let viewRect = self.bounds.integral
                let textSize = self.layoutManager.usedRect(for: self.textContainer).integral.size
                let textOffset = self.alignmentPoint(size: viewRect.size, textSize: textSize)
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
            let viewRect = self.bounds.integral
            let textSize = self.layoutManager.usedRect(for: self.textContainer).integral.size
            let textOffset = self.alignmentPoint(size: viewRect.size, textSize: textSize)
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
                width: self.currentPreferredMaxLayoutWidth(),
                height: CGFloat.greatestFiniteMagnitude
            ))
        }

        internal func currentPreferredMaxLayoutWidth() -> CGFloat {
            let maxLayoutWidth = self.preferredMaxLayoutWidth
            if maxLayoutWidth > CGFloat.leastNonzeroMagnitude {
                return maxLayoutWidth
            }
            if self.numberOfLines == 1 {
                return CGFloat.greatestFiniteMagnitude
            }
            return self.bounds.width
        }

        internal func updateTextStorage() {
            if let text = self.text {
                self.textStorage.setAttributedString(text.attributed)
            } else {
                self.textStorage.deleteAllCharacters()
            }
        }

        private func alignmentPoint(size: CGSize, textSize: CGSize) -> CGPoint {
            var x = size.width - textSize.width
            var y = size.height - textSize.height
            switch self.verticalAlignment {
            case .top: y = 0
            case .center: y = max(y / 2, 0)
            case .bottom: y = max(y, 0)
            }
            switch self.horizontalAlignment {
            case .left: x = 0
            case .center: x = max(x / 2, 0)
            case .right: x = max(x, 0)
            }
            return CGPoint(x: x, y: y)
        }

    }

#endif
