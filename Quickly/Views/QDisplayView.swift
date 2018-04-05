//
//  Quickly
//

open class QDisplayViewStyleSheet< TargetType: QDisplayView > : IQStyleSheet {

    public var cornerRadius: QViewCornerRadius
    public var border: QViewBorder

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

    open override var frame: CGRect {
        didSet { self.updateCornerRadius() }
    }
    open override var bounds: CGRect {
        didSet { self.updateCornerRadius() }
    }

    open override func setup() {
        super.setup()

        self.clipsToBounds = true
    }

    private func updateCornerRadius() {
        self.layer.cornerRadius = self.cornerRadius.compute(self.bounds)
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
    }
    
}
