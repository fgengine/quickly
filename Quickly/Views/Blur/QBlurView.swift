//
//  Quickly
//

open class QBlurView : UIVisualEffectView, IQView {
    
    public var blur: UIBlurEffect? {
        set(value) { super.effect = value }
        get { return super.effect as? UIBlurEffect }
    }
    
    public required init() {
        super.init(effect: nil)
        self.setup()
    }
    
    public init(blur: UIBlurEffect?) {
        super.init(effect: blur)
        self.setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    open func setup() {
    }

}
