//
//  Quickly
//

#if os(iOS)

    @IBDesignable
    open class QPinCodeView : QControl {

        @IBInspectable public var text: String = "" {
            didSet { self.setNeedsDisplay() }
        }
        @IBInspectable public var length: Int = 4 {
            didSet {
                self.invalidateIntrinsicContentSize()
                self.setNeedsDisplay()
            }
        }
        @IBInspectable public var color: UIColor = UIColor.black {
            didSet { self.setNeedsDisplay() }
        }
        @IBInspectable public var diameter: CGFloat = 16.0 {
            didSet {
                self.invalidateIntrinsicContentSize()
                self.setNeedsDisplay()
            }
        }
        @IBInspectable public var spacing: CGFloat = 16.0 {
            didSet {
                self.invalidateIntrinsicContentSize()
                self.setNeedsDisplay()
            }
        }
        @IBInspectable public var thickness: CGFloat = 1.0 {
            didSet {
                self.invalidateIntrinsicContentSize()
                self.setNeedsDisplay()
            }
        }
        public var isEmpty: Bool {
            get { return self.text.isEmpty }
        }
        public var isFilled: Bool {
            get { return self.text.count == self.length }
        }

        open override var intrinsicContentSize: CGSize {
            get {
                let width = CGFloat(self.length) * (self.diameter + self.spacing) - self.spacing + self.thickness
                let height = self.diameter + self.thickness
                return CGSize(width: width, height: height)
            }
        }

        public override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }

        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.setup()
        }

        public func append(number: Int) {
            if self.isFilled == false {
                self.text.append(String(number))
            }
        }

        public func removeLast() {
            if self.isEmpty == false {
                self.text.remove(at: self.text.index(self.text.endIndex, offsetBy: -1))
            }
        }

        open func drawDot(_ context: CGContext, origin: CGPoint, filled: Bool) {
            if filled == true {
                let dotRect = CGRect(origin: origin, size: CGSize(width: self.diameter + self.thickness, height: self.diameter + self.thickness))
                context.fillEllipse(in: dotRect)
            } else {
                let position = CGPoint(x: origin.x + self.thickness / 2, y: origin.y + self.thickness / 2)
                let dotRect = CGRect(origin: position, size: CGSize(width: self.diameter, height: self.diameter))
                context.strokeEllipse(in: dotRect)
            }
        }

        open override func draw(_ rect: CGRect) {
            var origin = CGPoint.zero
            if let context = UIGraphicsGetCurrentContext() {
                context.setFillColor(self.color.cgColor)
                context.setStrokeColor(self.color.cgColor)
                context.setLineWidth(self.thickness)
                for i in 0 ..< self.length {
                    self.drawDot(context, origin: origin, filled: i < self.text.count)
                    origin.x += self.diameter + self.spacing
                }
            }
        }

    }

#endif
