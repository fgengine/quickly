//
//  Quickly
//

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

    var fillColor: QPlatformColor? { get }
    var fillRule: QShapeModelFillRule { get }
    var strokeColor: QPlatformColor? { get }
    var strokeStart: CGFloat { get }
    var strokeEnd: CGFloat { get }
    var lineWidth: CGFloat { get }
    var miterLimit: CGFloat { get }
    var lineCap: QShapeModelLineCap { get }
    var lineJoin: QShapeModelLineJoid { get }
    var lineDashPhase: CGFloat { get }
    var lineDashPattern: [UInt]? { get }
    var size: CGSize { get }

    func make() -> QPlatformBezierPath?
    func prepare(_ bounds: CGRect) -> QPlatformBezierPath?

}

public extension IQShapeModel {

    func prepare(_ bounds: CGRect) -> QPlatformBezierPath? {
        guard let path = self.make() else { return nil }
        path.apply(CGAffineTransform(translationX: (bounds.width / 2), y: (bounds.height / 2)))
        return path
    }

}
