//
//  Quickly
//

#if os(iOS)

    public protocol IQShapeViewMesh : class {

        func prepare(_ bounds: CGRect) -> UIBezierPath?

    }

    @IBDesignable
    open class QShapeView : QView {

        public var model: IQShapeViewMesh? = nil {
            didSet { self.setNeedsLayout() }
        }
        public var shapeLayer: CAShapeLayer {
            get { return self.layer as! CAShapeLayer }
        }

        open override class var layerClass: AnyClass {
            get { return CAShapeLayer.self }
        }

        open override func layoutSubviews() {
            if let model: IQShapeViewMesh = self.model {
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
