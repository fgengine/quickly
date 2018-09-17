//
//  Quickly
//

open class QView : UIView, IQView {
    
    open override var backgroundColor: UIColor? {
        set(backgroundColor) {
            super.backgroundColor = backgroundColor
            if let backgroundColor = backgroundColor {
                self.isOpaque = backgroundColor.isOpaque
            } else {
                self.isOpaque = false
            }
        }
        get { return super.backgroundColor }
    }
    
    public required init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public convenience init(frame: CGRect, backgroundColor: UIColor) {
        self.init(frame: frame)
        self.backgroundColor = backgroundColor
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    open func setup() {
    }
    
}
