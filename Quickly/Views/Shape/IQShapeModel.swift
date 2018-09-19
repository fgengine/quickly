//
//  Quickly
//

public enum QShapeModelFillRule {
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

public enum QShapeModelLineCap {
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

public enum QShapeModelLineJoid {
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

    func make() -> UIBezierPath?
    func prepare(_ bounds: CGRect) -> UIBezierPath?

}

public extension IQShapeModel {

    func prepare(_ bounds: CGRect) -> UIBezierPath? {
        guard let path = self.make() else { return nil }
        path.apply(CGAffineTransform(translationX: (bounds.width / 2), y: (bounds.height / 2)))
        return path
    }

}
