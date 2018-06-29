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
    public var normalStyle: IQButtonStyle?
    public var highlightedStyle: IQButtonStyle?
    public var disabledStyle: IQButtonStyle?
    public var selectedStyle: IQButtonStyle?
    public var selectedHighlightedStyle: IQButtonStyle?
    public var selectedDisabledStyle: IQButtonStyle?
    public var spinnerPosition: QButtonSpinnerPosition
    public var spinnerViewType: QSpinnerViewType.Type?
    public var isSelected: Bool
    public var isEnabled: Bool

    public init(
        contentHorizontalAlignment: UIControlContentHorizontalAlignment = .center,
        contentVerticalAlignment: UIControlContentVerticalAlignment = .center,
        contentInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
        imagePosition: QButtonImagePosition = .left,
        imageInsets: UIEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2),
        textInsets: UIEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2),
        normalStyle: IQButtonStyle? = nil,
        highlightedStyle: IQButtonStyle? = nil,
        disabledStyle: IQButtonStyle? = nil,
        selectedStyle: IQButtonStyle? = nil,
        selectedHighlightedStyle: IQButtonStyle? = nil,
        selectedDisabledStyle: IQButtonStyle? = nil,
        spinnerPosition: QButtonSpinnerPosition = .fill,
        spinnerViewType: QSpinnerViewType.Type? = nil,
        isSelected: Bool = false,
        isEnabled: Bool = true
    ) {
        self.contentHorizontalAlignment = contentHorizontalAlignment
        self.contentVerticalAlignment = contentVerticalAlignment
        self.contentInsets = contentInsets
        self.imagePosition = imagePosition
        self.imageInsets = imageInsets
        self.textInsets = textInsets
        self.normalStyle = normalStyle
        self.highlightedStyle = highlightedStyle
        self.disabledStyle = disabledStyle
        self.selectedStyle = selectedStyle
        self.selectedHighlightedStyle = selectedHighlightedStyle
        self.selectedDisabledStyle = selectedDisabledStyle
        self.spinnerPosition = spinnerPosition
        self.spinnerViewType = spinnerViewType
        self.isSelected = isSelected
        self.isEnabled = isEnabled
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
