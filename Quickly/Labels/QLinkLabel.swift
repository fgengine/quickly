//
//  Quickly
//

import UIKit

open class QLinkLabel: QLabel {

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
                if let highlight: QTextStyle = self.highlight {
                    return highlight.attributes
                }
            }
            return self.normal.attributes
        }
        
    }

    public private(set) var pressGestureRecognizer: UILongPressGestureRecognizer? {
        willSet {
            if let gestureRecognizer: UILongPressGestureRecognizer = self.pressGestureRecognizer {
                self.removeGestureRecognizer(gestureRecognizer)
            }
        }
        didSet {
            if let gestureRecognizer: UILongPressGestureRecognizer = self.pressGestureRecognizer {
                self.addGestureRecognizer(gestureRecognizer)
            }
        }
    }
    public var links: [Link] = [] {
        didSet { self.updateTextStorage() }
    }

    public func appendLink(_ string: String, normal: QTextStyle, highlight: QTextStyle?, onPressed: @escaping PressedClosure) {
        guard let text: IQText = self.text else {
            return
        }
        guard let range: Range< String.Index > = text.attributed.string.range(of: string) else {
            return
        }
        self.links.append(Link(range, normal: normal, highlight: highlight, onPressed: onPressed))
        self.updateTextStorage()
    }

    public func appendLink(_ range: Range< String.Index >, normal: QTextStyle, highlight: QTextStyle?, onPressed: @escaping PressedClosure) {
        self.links.append(Link(range, normal: normal, highlight: highlight, onPressed: onPressed))
        self.updateTextStorage()
    }

    public func removeLink(_ range: Range< String.Index >) {
        var removeIndeces: [Int] = []
        var index: Int = 0
        for link: Link in self.links {
            if range.overlaps(link.range) == true {
                removeIndeces.append(index)
            }
            index += 1
        }
        for removeIndex: Int in removeIndeces {
            self.links.remove(at: removeIndex)
        }
        self.updateTextStorage()
    }

    public func removeAllLinks() {
        self.links.removeAll()
        self.updateTextStorage()
    }

    @IBAction private func handlePressGesture(_ gesture: UILongPressGestureRecognizer) {
        var needUpdate: Bool = false
        let point: CGPoint = gesture.location(in: self)
        if let charecterIndex: String.Index = self.characterIndex(point: point) {
            for link: Link in self.links {
                let highlighted: Bool = link.range.contains(charecterIndex)
                if link.isHighlighted != highlighted {
                    link.isHighlighted = highlighted
                    needUpdate = true
                }
            }
        } else {
            for link: Link in self.links {
                if link.isHighlighted == true {
                    link.isHighlighted = false
                    needUpdate = true
                }
            }
        }
        switch gesture.state {
        case .ended:
            for link: Link in self.links {
                if link.isHighlighted == true {
                    link.onPressed(self, link)
                }
            }
        default: break
        }
        if needUpdate == true {
            self.updateTextStorage()
        }
    }

    open override func setup() {
        super.setup()

        self.isUserInteractionEnabled = true

        let gestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(self.handlePressGesture(_:))
        )
        gestureRecognizer.delaysTouchesBegan = true
        gestureRecognizer.minimumPressDuration = 0.01
        self.pressGestureRecognizer = gestureRecognizer
    }

    internal override func updateTextStorage() {
        super.updateTextStorage()

        let string: String = self.textStorage.string
        let stringRange: Range< String.Index > = string.startIndex ..< string.endIndex
        for link: Link in self.links {
            let stringRange: Range< String.Index > = stringRange.clamped(to: link.range)
            let nsRange: NSRange = string.nsRange(from: stringRange)
            let attributes: [NSAttributedStringKey: Any] = link.attributes()
            self.textStorage.setAttributes(attributes, range: nsRange)
        }
    }

}
