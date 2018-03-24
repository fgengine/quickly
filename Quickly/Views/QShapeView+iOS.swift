//
//  Quickly
//

#if os(iOS)

    public enum QShapeModelFillRule {
        case nonZero
        case evenOdd

        public var string: String {
            get {
                switch self {
                case .nonZero: return kCAFillRuleNonZero
                case .evenOdd: return kCAFillRuleEvenOdd
                }
            }
        }
    }

    public enum QShapeModelLineCap {
        case butt
        case round
        case square

        public var string: String {
            get {
                switch self {
                case .butt: return kCALineCapButt
                case .round: return kCALineCapRound
                case .square: return kCALineCapSquare
                }
            }
        }
    }

    public enum QShapeModelLineJoid {
        case miter
        case round
        case bevel

        public var string: String {
            get {
                switch self {
                case .miter: return kCALineJoinMiter
                case .round: return kCALineJoinRound
                case .bevel: return kCALineJoinBevel
                }
            }
        }
    }

    public protocol IQShapeModel : class {

        var fillColor: UIColor? { get }
        var fillRule: QShapeModelFillRule { get }
        var strokeColor: UIColor? { get }
        var strokeStart: CGFloat { get }
        var strokeEnd: CGFloat { get }
        var lineWidth: CGFloat { get }
        var miterLimit: CGFloat { get }
        var lineCap: QShapeModelLineCap { get }
        var lineJoin: QShapeModelLineJoid { get }
        var lineDashPhase: CGFloat { get }
        var lineDashPattern: [UInt]? { get }
        var size: CGSize { get }

        func prepare(_ bounds: CGRect) -> UIBezierPath?

    }

    open class QShapeModel : IQShapeModel {

        open var fillColor: UIColor?
        open var fillRule: QShapeModelFillRule
        open var strokeColor: UIColor?
        open var strokeStart: CGFloat
        open var strokeEnd: CGFloat
        open var lineWidth: CGFloat
        open var miterLimit: CGFloat
        open var lineCap: QShapeModelLineCap
        open var lineJoin: QShapeModelLineJoid
        open var lineDashPhase: CGFloat
        open var lineDashPattern: [UInt]?
        open var size: CGSize

        public init(size: CGSize) {
            self.fillColor = nil
            self.fillRule = .nonZero
            self.strokeColor = nil
            self.strokeStart = 0
            self.strokeEnd = 1
            self.lineWidth = 1
            self.miterLimit = 10
            self.lineCap = .butt
            self.lineJoin = .miter
            self.lineDashPhase = 0
            self.lineDashPattern = nil
            self.size = size
        }

        open func prepare(_ bounds: CGRect) -> UIBezierPath? {
            return nil
        }

    }

    @IBDesignable
    open class QShapeView : QView {

        public var model: IQShapeModel? = nil {
            didSet {
                if let model: IQShapeModel = self.model {
                    if let fillColor: UIColor = model.fillColor {
                        self.shapeLayer.fillColor = fillColor.cgColor
                    } else {
                        self.shapeLayer.fillColor = nil
                    }
                    self.shapeLayer.fillRule = model.fillRule.string
                    if let strokeColor: UIColor = model.strokeColor {
                        self.shapeLayer.strokeColor = strokeColor.cgColor
                    } else {
                        self.shapeLayer.strokeColor = nil
                    }
                    self.shapeLayer.strokeStart = model.strokeStart
                    self.shapeLayer.strokeEnd = model.strokeEnd
                    self.shapeLayer.lineWidth = model.lineWidth
                    self.shapeLayer.miterLimit = model.miterLimit
                    self.shapeLayer.lineCap = model.lineCap.string
                    self.shapeLayer.lineJoin = model.lineJoin.string
                    self.shapeLayer.lineDashPhase = model.lineDashPhase
                    if let lineDashPattern: [UInt] = model.lineDashPattern {
                        self.shapeLayer.lineDashPattern = lineDashPattern.flatMap({ (value: UInt) -> NSNumber? in
                            return NSNumber(value: value)
                        })
                    } else {
                        self.shapeLayer.lineDashPattern = nil
                    }
                }
                self.invalidateIntrinsicContentSize()
                self.setNeedsLayout()
            }
        }
        public var shapeLayer: CAShapeLayer {
            get { return self.layer as! CAShapeLayer }
        }

        open override class var layerClass: AnyClass {
            get { return CAShapeLayer.self }
        }
        open override var intrinsicContentSize: CGSize {
            get {
                return self.sizeThatFits(self.bounds.size)
            }
        }

        open override func sizeThatFits(_ size: CGSize) -> CGSize {
            guard let model: IQShapeModel = self.model else { return CGSize.zero }
            return model.size
        }

        open override func sizeToFit() {
            super.sizeToFit()

            self.frame.size = self.sizeThatFits(self.bounds.size)
        }

        open override func layoutSubviews() {
            if let model: IQShapeModel = self.model {
                if let path = model.prepare(self.bounds) {
                    self.shapeLayer.path = path.cgPath
                } else {
                    self.shapeLayer.path = nil
                }
            } else {
                self.shapeLayer.path = nil
            }
        }

    }


#endif
