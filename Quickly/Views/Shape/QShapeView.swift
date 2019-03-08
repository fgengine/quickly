//
//  Quickly
//

open class QShapeView : QView {

    public var model: Model? {
        didSet {
            if let model = self.model {
                if let fillColor = model.fillColor {
                    self.shapeLayer.fillColor = fillColor.cgColor
                } else {
                    self.shapeLayer.fillColor = nil
                }
                self.shapeLayer.fillRule = CAShapeLayerFillRule(rawValue: model.fillRule.string)
                if let strokeColor = model.strokeColor {
                    self.shapeLayer.strokeColor = strokeColor.cgColor
                } else {
                    self.shapeLayer.strokeColor = nil
                }
                self.shapeLayer.strokeStart = model.strokeStart
                self.shapeLayer.strokeEnd = model.strokeEnd
                self.shapeLayer.lineWidth = model.lineWidth
                self.shapeLayer.miterLimit = model.miterLimit
                self.shapeLayer.lineCap = CAShapeLayerLineCap(rawValue: model.lineCap.string)
                self.shapeLayer.lineJoin = CAShapeLayerLineJoin(rawValue: model.lineJoin.string)
                self.shapeLayer.lineDashPhase = model.lineDashPhase
                if let lineDashPattern = model.lineDashPattern {
                    self.shapeLayer.lineDashPattern = lineDashPattern.compactMap({ (value: UInt) -> NSNumber? in
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
        guard let model = self.model else { return CGSize.zero }
        return model.size
    }

    open override func sizeToFit() {
        super.sizeToFit()

        self.frame.size = self.sizeThatFits(self.bounds.size)
    }

    open override func layoutSubviews() {
        if let model = self.model {
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

extension QShapeView {
    
    public enum FillRule {
        case nonZero
        case evenOdd
        
        public var string: String {
            get {
                switch self {
                case .nonZero: return CAShapeLayerFillRule.nonZero.rawValue
                case .evenOdd: return CAShapeLayerFillRule.evenOdd.rawValue
                }
            }
        }
    }
    
    public enum LineCap {
        case butt
        case round
        case square
        
        public var string: String {
            get {
                switch self {
                case .butt: return CAShapeLayerLineCap.butt.rawValue
                case .round: return CAShapeLayerLineCap.round.rawValue
                case .square: return CAShapeLayerLineCap.square.rawValue
                }
            }
        }
    }
    
    public enum LineJoid {
        case miter
        case round
        case bevel
        
        public var string: String {
            get {
                switch self {
                case .miter: return CAShapeLayerLineJoin.miter.rawValue
                case .round: return CAShapeLayerLineJoin.round.rawValue
                case .bevel: return CAShapeLayerLineJoin.bevel.rawValue
                }
            }
        }
    }
    
    open class Model {
        
        open var fillColor: UIColor?
        open var fillRule: FillRule
        open var strokeColor: UIColor?
        open var strokeStart: CGFloat
        open var strokeEnd: CGFloat
        open var lineWidth: CGFloat
        open var miterLimit: CGFloat
        open var lineCap: LineCap
        open var lineJoin: LineJoid
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
        
        open func make() -> UIBezierPath? {
            return nil
        }
        
        open func prepare(_ bounds: CGRect) -> UIBezierPath? {
            guard let path = self.make() else { return nil }
            path.apply(CGAffineTransform(translationX: (bounds.width / 2), y: (bounds.height / 2)))
            return path
        }
        
    }
    
}
