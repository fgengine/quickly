//
//  Quickly
//

open class QTextFieldStyleSheet : QDisplayStyleSheet {
    
    public var requireValidator: Bool
    public var validator: IQInputValidator?
    public var form: IQFieldForm?
    public var formatter: IQStringFormatter?
    public var textInsets: UIEdgeInsets
    public var textStyle: IQTextStyle?
    public var editingInsets: UIEdgeInsets?
    public var placeholderInsets: UIEdgeInsets?
    public var placeholder: IQText?
    public var typingStyle: IQTextStyle?
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
    public var suggestion: IQTextFieldSuggestion?
    
    public init(
        requireValidator: Bool = false,
        validator: IQInputValidator? = nil,
        form: IQFieldForm? = nil,
        formatter: IQStringFormatter? = nil,
        textInsets: UIEdgeInsets = UIEdgeInsets.zero,
        textStyle: IQTextStyle? = nil,
        editingInsets: UIEdgeInsets? = nil,
        placeholderInsets: UIEdgeInsets? = nil,
        placeholder: IQText? = nil,
        typingStyle: IQTextStyle? = nil,
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
        suggestion: IQTextFieldSuggestion? = nil,
        backgroundColor: UIColor? = nil,
        tintColor: UIColor? = nil,
        cornerRadius: QViewCornerRadius = .none,
        border: QViewBorder = .none,
        shadow: QViewShadow? = nil
    ) {
        self.requireValidator = requireValidator
        self.validator = validator
        self.form = form
        self.formatter = formatter
        self.textInsets = textInsets
        self.textStyle = textStyle
        self.editingInsets = editingInsets
        self.placeholderInsets = placeholderInsets
        self.placeholder = placeholder
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
        self.suggestion = suggestion
        
        super.init(
            backgroundColor: backgroundColor,
            tintColor: tintColor,
            cornerRadius: cornerRadius,
            border: border,
            shadow: shadow
        )
    }
    
    public init(_ styleSheet: QTextFieldStyleSheet) {
        self.requireValidator = styleSheet.requireValidator
        self.validator = styleSheet.validator
        self.form = styleSheet.form
        self.formatter = styleSheet.formatter
        self.textInsets = styleSheet.textInsets
        self.textStyle = styleSheet.textStyle
        self.editingInsets = styleSheet.editingInsets
        self.placeholderInsets = styleSheet.placeholderInsets
        self.placeholder = styleSheet.placeholder
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
        self.suggestion = styleSheet.suggestion
        
        super.init(styleSheet)
    }
    
}
