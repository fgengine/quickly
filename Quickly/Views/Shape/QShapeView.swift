//
//  Quickly
//

open class QShapeView : QView {

    public var model: IQShapeModel? {
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
