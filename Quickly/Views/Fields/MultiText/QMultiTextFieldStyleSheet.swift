//
//  Quickly
//

open class QMultiTextFieldStyleSheet : QDisplayStyleSheet {
    
    public var validator: IQInputValidator?
    public var form: IQFieldForm?
    public var textInsets: UIEdgeInsets
    public var textStyle: IQTextStyle?
    public var placeholderInsets: UIEdgeInsets
    public var placeholder: IQText?
    public var maximumNumberOfCharecters: UInt
    public var maximumNumberOfLines: UInt
    public var minimumHeight: CGFloat
    public var maximumHeight: CGFloat
    public var autocapitalizationType: UITextAutocapitalizationType
    public var autocorrectionType: UITextAutocorrectionType
    public var spellCheckingType: UITextSpellCheckingType
    public var keyboardType: UIKeyboardType
    public var keyboardAppearance: UIKeyboardAppearance
    public var returnKeyType: UIReturnKeyType
    public var enablesReturnKeyAutomatically: Bool
    public var isSecureTextEntry: Bool
    public var textContentType: UITextContentType!
    public var isEnabled: Bool
    public var toolbarStyle: QToolbarStyleSheet?
    public var toolbarActions: QFieldAction
    
    public init(
        validator: IQInputValidator? = nil,
        form: IQFieldForm? = nil,
        textInsets: UIEdgeInsets = UIEdgeInsets.zero,
        textStyle: IQTextStyle? = nil,
        placeholderInsets: UIEdgeInsets = UIEdgeInsets.zero,
        placeholder: IQText? = nil,
        maximumNumberOfCharecters: UInt = 0,
        maximumNumberOfLines: UInt = 0,
        minimumHeight: CGFloat = 0,
        maximumHeight: CGFloat = 0,
        autocapitalizationType: UITextAutocapitalizationType = .none,
        autocorrectionType: UITextAutocorrectionType = .default,
        spellCheckingType: UITextSpellCheckingType = .default,
        keyboardType: UIKeyboardType = .default,
        keyboardAppearance: UIKeyboardAppearance = .default,
        returnKeyType: UIReturnKeyType = .default,
        enablesReturnKeyAutomatically: Bool = true,
        isSecureTextEntry: Bool = false,
        textContentType: UITextContentType! = nil,
        isEnabled: Bool = true,
        toolbarStyle: QToolbarStyleSheet? = nil,
        toolbarActions: QFieldAction = [ .cancel, .done ],
        backgroundColor: UIColor? = nil,
        tintColor: UIColor? = nil,
        cornerRadius: QViewCornerRadius = .none,
        border: QViewBorder = .none,
        shadow: QViewShadow? = nil
    ) {
        self.validator = validator
        self.form = form
        self.textInsets = textInsets
        self.textStyle = textStyle
        self.placeholderInsets = placeholderInsets
        self.placeholder = placeholder
        self.maximumNumberOfCharecters = maximumNumberOfCharecters
        self.maximumNumberOfLines = maximumNumberOfLines
        self.minimumHeight = minimumHeight
        self.maximumHeight = maximumHeight
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.spellCheckingType = spellCheckingType
        self.keyboardType = keyboardType
        self.keyboardAppearance = keyboardAppearance
        self.returnKeyType = returnKeyType
        self.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
        self.isSecureTextEntry = isSecureTextEntry
        self.textContentType = textContentType
        self.isEnabled = isEnabled
        self.toolbarStyle = toolbarStyle
        self.toolbarActions = toolbarActions
        
        super.init(
            backgroundColor: backgroundColor,
            tintColor: tintColor,
            cornerRadius: cornerRadius,
            border: border,
            shadow: shadow
        )
    }
    
    public init(_ styleSheet: QMultiTextFieldStyleSheet) {
        self.validator = styleSheet.validator
        self.form = styleSheet.form
        self.textInsets = styleSheet.textInsets
        self.textStyle = styleSheet.textStyle
        self.placeholderInsets = styleSheet.placeholderInsets
        self.placeholder = styleSheet.placeholder
        self.maximumNumberOfCharecters = styleSheet.maximumNumberOfCharecters
        self.maximumNumberOfLines = styleSheet.maximumNumberOfLines
        self.minimumHeight = styleSheet.minimumHeight
        self.maximumHeight = styleSheet.maximumHeight
        self.autocapitalizationType = styleSheet.autocapitalizationType
        self.autocorrectionType = styleSheet.autocorrectionType
        self.spellCheckingType = styleSheet.spellCheckingType
        self.keyboardType = styleSheet.keyboardType
        self.keyboardAppearance = styleSheet.keyboardAppearance
        self.returnKeyType = styleSheet.returnKeyType
        self.enablesReturnKeyAutomatically = styleSheet.enablesReturnKeyAutomatically
        self.isSecureTextEntry = styleSheet.isSecureTextEntry
        self.textContentType = styleSheet.textContentType
        self.isEnabled = styleSheet.isEnabled
        self.toolbarStyle = styleSheet.toolbarStyle
        self.toolbarActions = styleSheet.toolbarActions
        
        super.init(styleSheet)
    }
    
}
