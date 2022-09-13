//
//  Quickly
//

import UIKit

open class QPincodeStyleSheet : QDisplayStyleSheet {
    
    public var length: Int = 4
    public var color: UIColor = UIColor.black
    public var diameter: CGFloat = 16.0
    public var spacing: CGFloat = 16.0
    public var thickness: CGFloat = 1.0
    
    public init(
        length: Int = 4,
        color: UIColor = UIColor.black,
        diameter: CGFloat = 16.0,
        spacing: CGFloat = 16.0,
        thickness: CGFloat = 1.0,
        backgroundColor: UIColor? = nil,
        cornerRadius: QViewCornerRadius = .none,
        border: QViewBorder = .none,
        shadow: QViewShadow? = nil
    ) {
        self.length = length
        self.color = color
        self.diameter = diameter
        self.spacing = spacing
        self.thickness = thickness
        
        super.init(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            border: border,
            shadow: shadow
        )
    }
    
    public init(_ styleSheet: QPincodeStyleSheet) {
        self.length = styleSheet.length
        self.color = styleSheet.color
        self.diameter = styleSheet.diameter
        self.spacing = styleSheet.spacing
        self.thickness = styleSheet.thickness
        
        super.init(styleSheet)
    }
    
}

open class QPincodeView : QDisplayView {

    public var text: String = "" {
        didSet { self.setNeedsDisplay() }
    }
    public var length: Int = 4 {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsDisplay()
        }
    }
    public var color: UIColor = UIColor.black {
        didSet { self.setNeedsDisplay() }
    }
    public var diameter: CGFloat = 16.0 {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsDisplay()
        }
    }
    public var spacing: CGFloat = 16.0 {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsDisplay()
        }
    }
    public var thickness: CGFloat = 1.0 {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsDisplay()
        }
    }
    public var isEmpty: Bool {
        get { return self.text.isEmpty }
    }
    public var isFilled: Bool {
        get { return self.text.count == self.length }
    }

    open override var intrinsicContentSize: CGSize {
        get {
            let width = CGFloat(self.length) * (self.diameter + self.spacing) - self.spacing + self.thickness
            let height = self.diameter + self.thickness
            return CGSize(width: width, height: height)
        }
    }
    
    public required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    public func append(number: Int) {
        if self.isFilled == false {
            self.text.append(String(number))
        }
    }

    public func removeLast() {
        if self.isEmpty == false {
            self.text.remove(at: self.text.index(self.text.endIndex, offsetBy: -1))
        }
    }
    
    public func apply(_ styleSheet: QPincodeStyleSheet) {
        self.apply(styleSheet as QDisplayStyleSheet)
        
        self.length = styleSheet.length
        self.color = styleSheet.color
        self.diameter = styleSheet.diameter
        self.spacing = styleSheet.spacing
        self.thickness = styleSheet.thickness
    }

    open override func draw(_ rect: CGRect) {
        let size = self.bounds.size
        let contentSize = CGSize(
            width: CGFloat(self.length) * (self.diameter + self.spacing) - self.spacing + self.thickness,
            height: self.diameter + self.thickness
        )
        var origin = CGPoint(
            x: (size.width / 2) - (contentSize.width / 2),
            y: (size.height / 2) - (contentSize.height / 2)
        )
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(self.color.cgColor)
            context.setStrokeColor(self.color.cgColor)
            context.setLineWidth(self.thickness)
            for i in 0 ..< self.length {
                if i < self.text.count {
                    self.drawFilledDot(context, origin: origin)
                } else {
                    self.drawDot(context, origin: origin)
                }
                origin.x += self.diameter + self.spacing
            }
        }
    }
    
    open func drawFilledDot(_ context: CGContext, origin: CGPoint) {
        let dotRect = CGRect(origin: origin, size: CGSize(width: self.diameter + self.thickness, height: self.diameter + self.thickness))
        context.fillEllipse(in: dotRect)
    }
    
    open func drawDot(_ context: CGContext, origin: CGPoint) {
        let position = CGPoint(x: origin.x + self.thickness / 2, y: origin.y + self.thickness / 2)
        let dotRect = CGRect(origin: position, size: CGSize(width: self.diameter, height: self.diameter))
        context.strokeEllipse(in: dotRect)
    }

}
