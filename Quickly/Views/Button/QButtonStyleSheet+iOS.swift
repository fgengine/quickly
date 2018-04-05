//
//  Quickly
//

#if os(iOS)

    public class QButtonStyleSheet : IQStyleSheet {

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

        public init(style: QButtonStyle) {
            self.contentHorizontalAlignment = .center
            self.contentVerticalAlignment = .center
            self.contentInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            self.imagePosition = .left
            self.imageInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            self.textInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            self.normalStyle = style
            self.spinnerPosition = .fill
            self.isSelected = false
            self.isEnabled = true
        }

        public func apply(target: QButton) {
            target.contentHorizontalAlignment = self.contentHorizontalAlignment
            target.contentVerticalAlignment = self.contentVerticalAlignment
            target.contentInsets = self.contentInsets
            target.imagePosition = self.imagePosition
            target.imageInsets = self.imageInsets
            target.textInsets = self.textInsets
            target.normalStyle = self.normalStyle
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

#endif
