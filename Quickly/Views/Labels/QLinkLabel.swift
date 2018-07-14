//
//  Quickly
//

open class QLinkLabel : QLabel {

    public typealias PressedClosure = (_ label: QLinkLabel, _ link: QLinkLabel.Link) -> Void

    public class Link {

        public var range: Range< String.Index >
        public var normal: QTextStyle
        public var highlight: QTextStyle?
        public var onPressed: PressedClosure
        public var isHighlighted: Bool

        public init(_ range: Range< String.Index >, normal: QTextStyle, highlight: QTextStyle?, onPressed: @escaping PressedClosure) {
            self.range = range
            self.normal = normal
            self.highlight = highlight
            self.onPressed = onPressed
            self.isHighlighted = false
        }

        public func attributes() -> [NSAttributedStringKey: Any] {
            if self.isHighlighted == true {
                if let highlight = self.highlight {
                    return highlight.attributes
                }
            }
            return self.normal.attributes
        }

    }

    public private(set) var pressGestureRecognizer: UILongPressGestureRecognizer? {
        willSet {
            if let gestureRecognizer = self.pressGestureRecognizer {
                self.removeGestureRecognizer(gestureRecognizer)
            }
        }
        didSet {
            if let gestureRecognizer = self.pressGestureRecognizer {
                self.addGestureRecognizer(gestureRecognizer)
            }
        }
    }
    public var links: [Link] = [] {
        didSet { self._updateTextStorage() }
    }

    public func appendLink(_ string: String, normal: QTextStyle, highlight: QTextStyle?, onPressed: @escaping PressedClosure) {
        guard let text = self.text else { return }
        guard let range = text.attributed.string.range(of: string) else { return }
        self.links.append(Link(range, normal: normal, highlight: highlight, onPressed: onPressed))
        self._updateTextStorage()
    }

    public func appendLink(_ range: Range< String.Index >, normal: QTextStyle, highlight: QTextStyle?, onPressed: @escaping PressedClosure) {
        self.links.append(Link(range, normal: normal, highlight: highlight, onPressed: onPressed))
        self._updateTextStorage()
    }

    public func removeLink(_ range: Range< String.Index >) {
        var removeIndeces: [Int] = []
        var index: Int = 0
        for link in self.links {
            if range.overlaps(link.range) == true {
                removeIndeces.append(index)
            }
            index += 1
        }
        for removeIndex in removeIndeces {
            self.links.remove(at: removeIndex)
        }
        self._updateTextStorage()
    }

    public func removeAllLinks() {
        self.links.removeAll()
        self._updateTextStorage()
    }

    @IBAction private func handlePressGesture(_ gesture: UILongPressGestureRecognizer) {
        var needUpdate = false
        let point = gesture.location(in: self)
        if let charecterIndex = self.characterIndex(point: point) {
            for link in self.links {
                let highlighted = link.range.contains(charecterIndex)
                if link.isHighlighted != highlighted {
                    link.isHighlighted = highlighted
                    needUpdate = true
                }
            }
        } else {
            for link in self.links {
                if link.isHighlighted == true {
                    link.isHighlighted = false
                    needUpdate = true
                }
            }
        }
        switch gesture.state {
        case .ended:
            for link in self.links {
                if link.isHighlighted == true {
                    link.onPressed(self, link)
                }
            }
        default: break
        }
        if needUpdate == true {
            self._updateTextStorage()
        }
    }

    open override func setup() {
        super.setup()

        self.isUserInteractionEnabled = true

        let gestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(self.handlePressGesture(_:))
        )
        gestureRecognizer.delaysTouchesBegan = true
        gestureRecognizer.minimumPressDuration = 0.01
        self.pressGestureRecognizer = gestureRecognizer
    }

    internal override func _updateTextStorage() {
        super._updateTextStorage()

        let string = self.textStorage.string
        let stringRange = string.startIndex ..< string.endIndex
        for link in self.links {
            let stringRange = stringRange.clamped(to: link.range)
            let nsRange = string.nsRange(from: stringRange)
            let attributes = link.attributes()
            self.textStorage.setAttributes(attributes, range: nsRange)
        }
    }

}
