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

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    open func setup() {
    }
    
}
