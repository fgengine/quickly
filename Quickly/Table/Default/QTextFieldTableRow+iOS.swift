//
//  Quickly
//

#if os(iOS)

    open class QTextFieldTableRow: QBackgroundColorTableRow {

        public var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
        public var height: CGFloat = 44

        public var fieldRequireValidator: Bool = true
        public var fieldValidator: IQInputValidator? = nil
        public var fieldIsValid: Bool = true
        public var fieldFormatter: IQStringFormatter? = nil
        public var fieldTextInsets: UIEdgeInsets = UIEdgeInsets.zero
        public var fieldTextAlignment: NSTextAlignment = .left
        public var fieldTextStyle: QTextStyle? = nil
        public var fieldText: String = ""
        public var fieldPlaceholder: IQText? = nil
        public var fieldTypingStyle: QTextStyle? = nil
        public var fieldAutocapitalizationType: UITextAutocapitalizationType = .none
        public var fieldAutocorrectionType: UITextAutocorrectionType = .default
        public var fieldSpellCheckingType: UITextSpellCheckingType = .default
        public var fieldKeyboardType: UIKeyboardType = .default
        public var fieldKeyboardAppearance: UIKeyboardAppearance = .default
        public var fieldReturnKeyType: UIReturnKeyType = .default
        public var fieldEnablesReturnKeyAutomatically: Bool = true
        public var fieldIsSecureTextEntry: Bool = false
        public var fieldTextContentType: UITextContentType! = nil
        public var fieldIsEditing: Bool = false
        public var fieldIsEnabled: Bool = true

    }

#endif
