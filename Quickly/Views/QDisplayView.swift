//
//  Quickly
//

open class QDisplayViewStyleSheet< TargetType: QDisplayView > : IQStyleSheet {

    public var cornerRadius: QViewCornerRadius
    public var border: QViewBorder
    public var shadow: QViewShadow?

    public init() {
        self.cornerRadius = .none
        self.border = .none
    }

    public func apply(target: TargetType) {
        target.cornerRadius = self.cornerRadius
        target.border = self.border
    }

}

open class QDisplayView : QView {

    public var cornerRadius: QViewCornerRadius = .none {
        didSet { self.updateCornerRadius() }
    }
    public var border: QViewBorder = .none {
        didSet { self.updateBorder() }
    }
    public var shadow: QViewShadow? {
        didSet { self.updateShadow() }
    }
    open override var frame: CGRect {
        didSet { self.updateCornerRadius() }
    }
    open override var bounds: CGRect {
        didSet { self.updateCornerRadius() }
    }

    private func updateCornerRadius() {
        self.layer.cornerRadius = self.cornerRadius.compute(self.bounds)
        self.updateShadowPath()
    }

    private func updateBorder() {
        switch self.border {
        case .none:
            self.layer.borderWidth = 0
            self.layer.borderColor = nil
            break
        case .manual(let width, let color):
            self.layer.borderWidth = width
            self.layer.borderColor = color.cgColor
            break
        }
        self.updateShadowPath()
    }

    private func updateShadow() {
        if let shadow = self.shadow {
            self.layer.shadowColor = shadow.color.cgColor
            self.layer.shadowOpacity = Float(shadow.opacity)
            self.layer.shadowRadius = shadow.radius
            self.layer.shadowOffset = shadow.offset
        } else {
            self.layer.shadowColor = nil
        }
        self.updateShadowPath()
    }

    private func updateShadowPath() {
        if self.layer.shadowColor != nil {
            let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius)
            self.layer.shadowPath = path.cgPath
        } else {
            self.layer.shadowPath = nil
        }
    }
    
}
