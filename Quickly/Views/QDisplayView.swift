//
//  Quickly
//

open class QDisplayStyleSheet : IQStyleSheet {

    public var backgroundColor: UIColor?
    public var tintColor: UIColor?
    public var cornerRadius: QViewCornerRadius
    public var border: QViewBorder
    public var shadow: QViewShadow?

    public init(
        backgroundColor: UIColor? = nil,
        tintColor: UIColor? = nil,
        cornerRadius: QViewCornerRadius = .none,
        border: QViewBorder = .none,
        shadow: QViewShadow? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.cornerRadius = cornerRadius
        self.border = border
        self.shadow = shadow
    }

    public init(_ styleSheet: QDisplayStyleSheet) {
        self.backgroundColor = styleSheet.backgroundColor
        self.tintColor = styleSheet.tintColor
        self.cornerRadius = styleSheet.cornerRadius
        self.border = styleSheet.border
        self.shadow = styleSheet.shadow
    }

}

open class QDisplayView : QView {

    public var cornerRadius: QViewCornerRadius = .none {
        didSet { self._updateCornerRadius() }
    }
    public var border: QViewBorder = .none {
        didSet { self._updateBorder() }
    }
    public var shadow: QViewShadow? {
        didSet { self._updateShadow() }
    }
    open override var frame: CGRect {
        didSet { self._updateCornerRadius() }
    }
    open override var bounds: CGRect {
        didSet { self._updateCornerRadius() }
    }

    open override func setup() {
        super.setup()

        self.clipsToBounds = true
    }
    
    public func apply(_ styleSheet: QDisplayStyleSheet) {
        self.backgroundColor = styleSheet.backgroundColor
        self.tintColor = styleSheet.tintColor
        self.cornerRadius = styleSheet.cornerRadius
        self.border = styleSheet.border
        self.shadow = styleSheet.shadow
    }
    
}

extension QDisplayView {

    private func _updateCornerRadius() {
        self.layer.cornerRadius = self.cornerRadius.compute(self.bounds)
        self._updateShadowPath()
    }

    private func _updateBorder() {
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
        self._updateShadowPath()
    }

    private func _updateShadow() {
        if let shadow = self.shadow {
            self.layer.shadowColor = shadow.color.cgColor
            self.layer.shadowOpacity = Float(shadow.opacity)
            self.layer.shadowRadius = shadow.radius
            self.layer.shadowOffset = shadow.offset
            self.clipsToBounds = false
        } else {
            self.layer.shadowColor = nil
            self.clipsToBounds = true
        }
        self._updateShadowPath()
    }

    private func _updateShadowPath() {
        if self.layer.shadowColor != nil {
            let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius)
            self.layer.shadowPath = path.cgPath
        } else {
            self.layer.shadowPath = nil
        }
    }
    
}
