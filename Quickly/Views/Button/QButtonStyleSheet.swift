//
//  Quickly
//

open class QButtonStyleSheet : IQStyleSheet {

    public var contentHorizontalAlignment: UIControlContentHorizontalAlignment
    public var contentVerticalAlignment: UIControlContentVerticalAlignment
    public var contentInsets: UIEdgeInsets
    public var imagePosition: QButtonImagePosition
    public var imageInsets: UIEdgeInsets
    public var textInsets: UIEdgeInsets
    public var normalStyle: QButtonStyle?
    public var highlightedStyle: QButtonStyle?
    public var disabledStyle: QButtonStyle?
    public var selectedStyle: QButtonStyle?
    public var selectedHighlightedStyle: QButtonStyle?
    public var selectedDisabledStyle: QButtonStyle?
    public var spinnerPosition: QButtonSpinnerPosition
    public var spinnerViewType: QSpinnerViewType.Type?
    public var isSelected: Bool
    public var isEnabled: Bool

    public init() {
        self.contentHorizontalAlignment = .center
        self.contentVerticalAlignment = .center
        self.contentInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.imagePosition = .left
        self.imageInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        self.textInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        self.spinnerPosition = .fill
        self.isSelected = false
        self.isEnabled = true
    }

    public init(_ styleSheet: QButtonStyleSheet) {
        self.contentHorizontalAlignment = styleSheet.contentHorizontalAlignment
        self.contentVerticalAlignment = styleSheet.contentVerticalAlignment
        self.contentInsets = styleSheet.contentInsets
        self.imagePosition = styleSheet.imagePosition
        self.imageInsets = styleSheet.imageInsets
        self.textInsets = styleSheet.textInsets
        self.normalStyle = styleSheet.normalStyle
        self.highlightedStyle = styleSheet.highlightedStyle
        self.disabledStyle = styleSheet.disabledStyle
        self.selectedStyle = styleSheet.selectedStyle
        self.selectedHighlightedStyle = styleSheet.selectedHighlightedStyle
        self.selectedDisabledStyle = styleSheet.selectedDisabledStyle
        self.spinnerPosition = styleSheet.spinnerPosition
        self.spinnerViewType = styleSheet.spinnerViewType
        self.isSelected = styleSheet.isSelected
        self.isEnabled = styleSheet.isEnabled
    }

    public func apply(target: QButton) {
        target.contentHorizontalAlignment = self.contentHorizontalAlignment
        target.contentVerticalAlignment = self.contentVerticalAlignment
        target.contentInsets = self.contentInsets
        target.imagePosition = self.imagePosition
        target.imageInsets = self.imageInsets
        target.textInsets = self.textInsets
        target.normalStyle = self.normalStyle
        target.highlightedStyle = self.highlightedStyle
        target.selectedStyle = self.selectedStyle
        target.selectedHighlightedStyle = self.selectedHighlightedStyle
        target.selectedDisabledStyle = self.selectedDisabledStyle
        target.spinnerPosition = self.spinnerPosition
        if let spinnerViewType = self.spinnerViewType {
            target.spinnerView = spinnerViewType.init()
        } else {
            target.spinnerView = nil
        }
        target.isSelected = self.isSelected
        target.isEnabled = self.isEnabled
    }

}
