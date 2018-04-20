//
//  Quickly
//

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

    open func make() -> UIBezierPath? {
        return nil
    }

}
