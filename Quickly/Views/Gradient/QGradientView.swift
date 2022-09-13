//
//  Quickly
//

import UIKit

open class QGradientStyleSheet : IQStyleSheet {

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
    }

    public init(_ styleSheet: QGradientStyleSheet) {
        self.points = styleSheet.points
        self.startPoint = styleSheet.startPoint
        self.endPoint = styleSheet.endPoint
    }

}

open class QGradientView : QView {

    public var points: [Point] = [] {
        didSet {
            self.gradientLayer.colors = self.points.compactMap({ return $0.color.cgColor })
            self.gradientLayer.locations = self.points.compactMap({ return NSNumber(value: Float($0.location)) })
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
    
    open override func setup() {
        super.setup()
        
        self.backgroundColor = UIColor.clear
    }
    
    public func apply(_ styleSheet: QGradientStyleSheet) {
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
