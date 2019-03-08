//
//  Quickly
//

open class QGradientStyleSheet : QDisplayStyleSheet {

    public var points: [QGradientView.Point]
    public var startPoint: CGPoint
    public var endPoint: CGPoint

    public init(
        points: [QGradientView.Point],
        startPoint: CGPoint = CGPoint(x: 0, y: 0),
        endPoint: CGPoint = CGPoint(x: 0, y: 1)
    ) {
        self.points = points
        self.startPoint = startPoint
        self.endPoint = endPoint

        super.init(backgroundColor: UIColor.clear)
    }

    public init(_ styleSheet: QGradientStyleSheet) {
        self.points = styleSheet.points
        self.startPoint = styleSheet.startPoint
        self.endPoint = styleSheet.endPoint

        super.init(styleSheet)
    }

}

open class QGradientView : QDisplayView {

    public var points: [Point] {
        set(value) {
            self.gradientLayer.colors = value.compactMap({ return $0.color.cgColor })
            self.gradientLayer.locations = value.compactMap({ return NSNumber(value: Float($0.location)) })
        }
        get {
            guard let colors = self.gradientLayer.colors as? [CGColor], let locations = self.gradientLayer.locations else { return [] }
            let count = max(locations.count, locations.count)
            return (0..<count).compactMap({
                return Point(
                    color: UIColor(cgColor: colors[$0]),
                    location: CGFloat(locations[$0].floatValue)
                )
            })
        }
    }
    public var startPoint: CGPoint {
        set(value) { self.gradientLayer.startPoint = value }
        get { return self.gradientLayer.startPoint }
    }
    public var endPoint: CGPoint {
        set(value) { self.gradientLayer.endPoint = value }
        get { return self.gradientLayer.endPoint }
    }
    public var gradientLayer: CAGradientLayer {
        get { return self.layer as! CAGradientLayer }
    }

    open override class var layerClass: AnyClass {
        get { return CAGradientLayer.self }
    }
    
    public func apply(_ styleSheet: QGradientStyleSheet) {
        self.apply(styleSheet as QDisplayStyleSheet)
        
        self.points = styleSheet.points
        self.startPoint = styleSheet.startPoint
        self.endPoint = styleSheet.endPoint
    }

}

extension QGradientView {
    
    public struct Point {
        
        public let color: UIColor
        public let location: CGFloat
        
        public init(color: UIColor, location: CGFloat) {
            self.color = color
            self.location = location
        }
        
    }
    
}
