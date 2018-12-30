//
//  Quickly
//

open class QSwitchStyleSheet : IQStyleSheet {
    
    public var tintColor: UIColor?
    public var onTintColor: UIColor?
    public var thumbTintColor: UIColor?
    public var onImage: UIImage?
    public var offImage: UIImage?
    
    public init(
        tintColor: UIColor? = nil,
        onTintColor: UIColor? = nil,
        thumbTintColor: UIColor? = nil,
        onImage: UIImage? = nil,
        offImage: UIImage? = nil
    ) {
        self.tintColor = tintColor
        self.onTintColor = onTintColor
        self.thumbTintColor = thumbTintColor
        self.onImage = onImage
        self.offImage = offImage
    }
    
    public init(_ styleSheet: QSwitchStyleSheet) {
        self.tintColor = styleSheet.tintColor
        self.onTintColor = styleSheet.onTintColor
        self.thumbTintColor = styleSheet.thumbTintColor
        self.onImage = styleSheet.onImage
        self.offImage = styleSheet.offImage
    }
    
}

open class QSwitch : UISwitch, IQView {
    
    public required init() {
        super.init(frame: CGRect.zero)
        self.setup()
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
    
    public func apply(_ styleSheet: QSwitchStyleSheet) {
        self.tintColor = styleSheet.tintColor
        self.onTintColor = styleSheet.onTintColor
        self.thumbTintColor = styleSheet.thumbTintColor
        self.onImage = styleSheet.onImage
        self.offImage = styleSheet.offImage
    }
    
}
