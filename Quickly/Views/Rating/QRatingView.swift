//
//  Quickly
//

import UIKit

open class QRatingStyleSheet : IQStyleSheet {
    
    public var starSize: CGSize
    public var numberOfStars: UInt
    public var rating: CGFloat
    public var fillColor: UIColor
    public var unfilledColor: UIColor
    public var strokeColor: UIColor
    public var lineWidth: CGFloat
    public var padding: CGFloat
    public var editable: Bool
    public var allowsTapWhenEditable: Bool
    public var allowsSwipeWhenEditable: Bool
    public var allowsHalfIntegralRatings: Bool
    
    public init(
        starSize: CGSize = CGSize(width: 40, height: 40),
        numberOfStars: UInt = 5,
        rating: CGFloat = 0,
        fillColor: UIColor = UIColor.blue,
        unfilledColor: UIColor = UIColor.clear,
        strokeColor: UIColor = UIColor.blue,
        lineWidth: CGFloat = 1,
        padding: CGFloat = 8,
        editable: Bool = true,
        allowsTapWhenEditable: Bool = true,
        allowsSwipeWhenEditable: Bool = true,
        allowsHalfIntegralRatings: Bool = true
    ) {
        self.starSize = starSize
        self.numberOfStars = numberOfStars
        self.rating = rating
        self.fillColor = fillColor
        self.unfilledColor = unfilledColor
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
        self.padding = padding
        self.editable = editable
        self.allowsTapWhenEditable = allowsTapWhenEditable
        self.allowsSwipeWhenEditable = allowsSwipeWhenEditable
        self.allowsHalfIntegralRatings = allowsHalfIntegralRatings
    }
}

open class QRatingView : QView {
    
    public typealias ChangedClosure = (_ ratingView: QRatingView, _ rating: CGFloat) -> Void
    
    public var starSize: CGSize = CGSize(width: 40, height: 40) {
        didSet(oldValue) {
            if self.starSize != oldValue {
                self.setNeedsDisplay()
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    public var numberOfStars: UInt = 5 {
        didSet(oldValue) {
            if self.numberOfStars != oldValue {
                self.setNeedsDisplay()
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    public var rating: CGFloat = 0 {
        didSet(oldValue) {
            if self.rating != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    public var fillColor: UIColor = UIColor.blue {
        didSet(oldValue) {
            if self.fillColor != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    public var unfilledColor: UIColor = UIColor.clear {
        didSet(oldValue) {
            if self.unfilledColor != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    public var strokeColor: UIColor = UIColor.blue {
        didSet(oldValue) {
            if self.strokeColor != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    public var lineWidth: CGFloat = 1 {
        didSet(oldValue) {
            if self.lineWidth != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    public var padding: CGFloat = 8 {
        didSet(oldValue) {
            if self.padding != oldValue {
                self.setNeedsDisplay()
                self.invalidateIntrinsicContentSize()
            }
        }
    }
    public var editable: Bool = true
    public var allowsTapWhenEditable: Bool = true
    public var allowsSwipeWhenEditable: Bool = true
    public var allowsHalfIntegralRatings: Bool = true
    
    public var onChanged: ChangedClosure?
    
    open override var intrinsicContentSize: CGSize {
        get {
            return CGSize(
                width: ((self.starSize.width + 1) * CGFloat(self.numberOfStars)) + (self.padding * CGFloat(self.numberOfStars)),
                height: (self.starSize.height + 1)
            )
        }
    }
    
    private lazy var _tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self._handleTapGesture(_:)))
        return gesture
    }()
    private lazy var _panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self._handlePanGesture(_:)))
        return gesture
    }()
    
    open override func setup() {
        super.setup()
        
        self.frame = CGRect(
            origin: self.frame.origin,
            size: self.intrinsicContentSize
        )
        self.backgroundColor = UIColor.clear
        
        self.addGestureRecognizer(self._tapGesture)
        self.addGestureRecognizer(self._panGesture)
    }
    
    public func apply(_ styleSheet: QRatingStyleSheet) {
        self.starSize = styleSheet.starSize
        self.numberOfStars = styleSheet.numberOfStars
        self.rating = styleSheet.rating
        self.fillColor = styleSheet.fillColor
        self.unfilledColor = styleSheet.unfilledColor
        self.strokeColor = styleSheet.strokeColor
        self.lineWidth = styleSheet.lineWidth
        self.padding = styleSheet.padding
        self.editable = styleSheet.editable
        self.allowsTapWhenEditable = styleSheet.allowsTapWhenEditable
        self.allowsSwipeWhenEditable = styleSheet.allowsSwipeWhenEditable
        self.allowsHalfIntegralRatings = styleSheet.allowsHalfIntegralRatings
    }
    
    open override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            var point = CGPoint(x: self.padding, y: 0)
            for index in 0..<self.numberOfStars {
                self._draw(
                    context: context,
                    at: point,
                    in: CGRect(origin: point, size: self.starSize),
                    star: index
                )
                point.x += self.starSize.width + self.padding
            }
        }
    }
    
    open func starPath(in rect: CGRect) -> UIBezierPath {
        let x = rect.origin.x
        let y = rect.origin.y
        let width = rect.width
        let height = rect.height
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x + 0.50000 * width, y: y + 0.00000 * height))
        path.addLine(to: CGPoint(x: x + 0.60940 * width, y: y + 0.34942 * height))
        path.addLine(to: CGPoint(x: x + 0.97553 * width, y: y + 0.34549 * height))
        path.addLine(to: CGPoint(x: x + 0.67702 * width, y: y + 0.55752 * height))
        path.addLine(to: CGPoint(x: x + 0.79389 * width, y: y + 0.90451 * height))
        path.addLine(to: CGPoint(x: x + 0.50000 * width, y: y + 0.68613 * height))
        path.addLine(to: CGPoint(x: x + 0.20611 * width, y: y + 0.90451 * height))
        path.addLine(to: CGPoint(x: x + 0.32298 * width, y: y + 0.55752 * height))
        path.addLine(to: CGPoint(x: x + 0.02447 * width, y: y + 0.34549 * height))
        path.addLine(to: CGPoint(x: x + 0.39060 * width, y: y + 0.34942 * height))
        path.close()
        return path
    }
    
    // MARK : Private
    
    @objc
    private func _handleTapGesture(_ gesture: UITapGestureRecognizer) {
        if self.editable == false || self.allowsTapWhenEditable == false {
            return
        }
        self.rating = self._rating(at: gesture.location(in: self))
    }
    
    @objc
    private func _handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        if self.editable == false || self.allowsSwipeWhenEditable == false {
            return
        }
        self.rating = self._rating(at: gesture.location(in: self))
    }
    
    private func _rating(at point: CGPoint) -> CGFloat {
        let rating = (point.x / (self.starSize.width + self.padding)) + 1
        var fractional = round(fmod(rating, 1) * 2) / 2
        if self.allowsHalfIntegralRatings == false {
            fractional = 0.5
        }
        return max(1, min(CGFloat(UInt(rating)) + fractional - 0.5, CGFloat(self.numberOfStars)))
    }
    
    private func _draw(context: CGContext, at point: CGPoint, in frame: CGRect, star index: UInt) {
        let path = self.starPath(in: frame)
        context.saveGState()
        path.addClip()
        self._drawFill(context: context, for: path.bounds, star: index)
        context.resetClip()
        self.strokeColor.setStroke()
        path.lineWidth = self.lineWidth
        path.stroke()
    }
    
    private func _drawFill(context: CGContext, for bounds: CGRect, star index: UInt) {
        let fillPercentage = self._fillPercentage(star: index)
        let colors = [ self.fillColor.cgColor, self.unfilledColor.cgColor, self.unfilledColor.cgColor ]
        let locations = [ fillPercentage, fillPercentage, fillPercentage ]
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: locations) {
            context.drawLinearGradient(
                gradient,
                start: CGPoint(x: bounds.minX, y: bounds.midY),
                end: CGPoint(x: bounds.maxX, y: bounds.midY),
                options: []
            )
        }
    }
    
    private func _fillPercentage(star index: UInt) -> CGFloat {
        let star = CGFloat(index) + 1
        if star <= self.rating {
            return 1.0
        } else if (star - 0.5) <= self.rating {
            return 0.5
        }
        return 0
    }
    
}
