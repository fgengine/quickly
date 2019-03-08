//
//  Quickly
//

open class QSegmentedControlStyleSheet : IQStyleSheet {
    
    public var items: [QSegmentedControl.Item]
    public var isMomentary: Bool
    public var apportionsSegmentWidthsByContent: Bool
    public var normalTextStyle: IQTextStyle?
    public var highlightedTextStyle: IQTextStyle?
    public var disabledTextStyle: IQTextStyle?
    public var selectedTextStyle: IQTextStyle?
    
    public init(
        items: [QSegmentedControl.Item],
        isMomentary: Bool = false,
        apportionsSegmentWidthsByContent: Bool = false,
        normalTextStyle: IQTextStyle? = nil,
        highlightedTextStyle: IQTextStyle? = nil,
        disabledTextStyle: IQTextStyle? = nil,
        selectedTextStyle: IQTextStyle? = nil
    ) {
        self.items = items
        self.isMomentary = isMomentary
        self.apportionsSegmentWidthsByContent = apportionsSegmentWidthsByContent
        self.normalTextStyle = normalTextStyle
        self.highlightedTextStyle = highlightedTextStyle
        self.disabledTextStyle = disabledTextStyle
        self.selectedTextStyle = selectedTextStyle
    }
    
    public init(_ styleSheet: QSegmentedControlStyleSheet) {
        self.items = styleSheet.items
        self.isMomentary = styleSheet.isMomentary
        self.apportionsSegmentWidthsByContent = styleSheet.apportionsSegmentWidthsByContent
        self.normalTextStyle = styleSheet.normalTextStyle
        self.highlightedTextStyle = styleSheet.highlightedTextStyle
        self.disabledTextStyle = styleSheet.disabledTextStyle
        self.selectedTextStyle = styleSheet.selectedTextStyle
    }
    
}

open class QSegmentedControl : UISegmentedControl, IQView {
    
    public typealias SelectedClosure = (_ segment: QSegmentedControl, _ selectedItem: QSegmentedControl.Item?) -> Void
    
    public var items: [QSegmentedControl.Item] = [] {
        didSet {
            self.removeAllSegments()
            for item in self.items {
                if let text = item.text {
                    self.insertSegment(withTitle: text, at: self.numberOfSegments, animated: false)
                } else if let image = item.image {
                    self.insertSegment(with: image, at: self.numberOfSegments, animated: false)
                }
            }
        }
    }
    public var selectedItem: QSegmentedControl.Item? {
        set(value) {
            if let selectedItem = value {
                if let index = self.items.firstIndex(where: { return $0 === selectedItem }) {
                    self.selectedSegmentIndex = index
                } else {
                    self.selectedSegmentIndex = UISegmentedControl.noSegment
                }
            } else {
                self.selectedSegmentIndex = UISegmentedControl.noSegment
            }
        }
        get {
            if self.selectedSegmentIndex == UISegmentedControl.noSegment {
                return nil
            }
            return self.items[self.selectedSegmentIndex]
        }
    }
    public var normalTextStyle: IQTextStyle? {
        didSet {
            if let textStyle = self.normalTextStyle {
                self.setTitleTextAttributes(textStyle.attributes, for: .normal)
            } else {
                self.setTitleTextAttributes(nil, for: .normal)
            }
        }
    }
    public var highlightedTextStyle: IQTextStyle? {
        didSet {
            if let textStyle = self.highlightedTextStyle {
                self.setTitleTextAttributes(textStyle.attributes, for: .highlighted)
            } else {
                self.setTitleTextAttributes(nil, for: .normal)
            }
        }
    }
    public var disabledTextStyle: IQTextStyle? {
        didSet {
            if let textStyle = self.disabledTextStyle {
                self.setTitleTextAttributes(textStyle.attributes, for: .disabled)
            } else {
                self.setTitleTextAttributes(nil, for: .disabled)
            }
        }
    }
    public var selectedTextStyle: IQTextStyle? {
        didSet {
            if let textStyle = self.selectedTextStyle {
                self.setTitleTextAttributes(textStyle.attributes, for: .selected)
            } else {
                self.setTitleTextAttributes(nil, for: .selected)
            }
        }
    }
    public var onSelected: SelectedClosure?
    
    public required init() {
        super.init(items: [])
        self.setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    open func setup() {
        self.addTarget(self, action: #selector(self._handleChanged(_:)), for: .valueChanged)
    }
    
    deinit {
        self.removeTarget(self, action: #selector(self._handleChanged(_:)), for: .valueChanged)
    }
    
    public func apply(_ styleSheet: QSegmentedControlStyleSheet) {
        self.items = styleSheet.items
        self.isMomentary = styleSheet.isMomentary
        self.apportionsSegmentWidthsByContent = styleSheet.apportionsSegmentWidthsByContent
        self.normalTextStyle = styleSheet.normalTextStyle
        self.highlightedTextStyle = styleSheet.highlightedTextStyle
        self.disabledTextStyle = styleSheet.disabledTextStyle
        self.selectedTextStyle = styleSheet.selectedTextStyle
    }
    
    @objc
    private func _handleChanged(_ sender: Any) {
        guard let onSelected = self.onSelected else { return }
        onSelected(self, self.selectedItem)
    }
    
}

extension QSegmentedControl {
    
    open class Item {
        
        public var text: String?
        public var image: UIImage?
        public var width: CGFloat?
        public var enabled: Bool
        
        public init(
            text: String,
            width: CGFloat? = nil,
            enabled: Bool = true
            ) {
            self.text = text
            self.width = width
            self.enabled = enabled
        }
        
        public init(
            image: UIImage,
            width: CGFloat? = nil,
            enabled: Bool = true
            ) {
            self.image = image
            self.width = width
            self.enabled = enabled
        }
        
    }
    
}
