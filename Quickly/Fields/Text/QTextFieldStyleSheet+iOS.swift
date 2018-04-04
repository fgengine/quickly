//
//  Quickly
//

#if os(iOS)

    public struct QTextFieldStyleSheet : IQStyleSheet {

        public var requireValidator: Bool
        public var validator: IQInputValidator?
        public var formatter: IQStringFormatter?
        public var textInsets: UIEdgeInsets
        public var textStyle: QTextStyle?
        public var editingInsets: UIEdgeInsets
        public var placeholderInsets: UIEdgeInsets
        public var placeholder: IQText?
        public var typingStyle: QTextStyle?
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

        public init() {
            self.requireValidator = true
            self.textInsets = UIEdgeInsets.zero
            self.editingInsets = UIEdgeInsets.zero
            self.placeholderInsets = UIEdgeInsets.zero
            self.autocapitalizationType = .none
            self.autocorrectionType = .default
            self.spellCheckingType = .default
            self.keyboardType = .default
            self.keyboardAppearance = .default
            self.returnKeyType = .default
            self.enablesReturnKeyAutomatically = true
            self.isSecureTextEntry = false
            self.textContentType = nil
            self.isEnabled = true
        }

        public func apply(target: QTextField) {
            target.requireValidator = self.requireValidator
            target.validator = self.validator
            target.formatter = self.formatter
            target.textInsets = self.textInsets
            target.textStyle = self.textStyle
            target.editingInsets = self.editingInsets
            target.placeholderInsets = self.placeholderInsets
            target.placeholder = self.placeholder
            target.typingStyle = self.typingStyle
            target.autocapitalizationType = self.autocapitalizationType
            target.autocorrectionType = self.autocorrectionType
            target.spellCheckingType = self.spellCheckingType
            target.keyboardType = self.keyboardType
            target.keyboardAppearance = self.keyboardAppearance
            target.returnKeyType = self.returnKeyType
            target.enablesReturnKeyAutomatically = self.enablesReturnKeyAutomatically
            target.isSecureTextEntry = self.isSecureTextEntry
            if #available(iOS 10.0, *) {
                target.textContentType = self.textContentType
            }
            target.isEnabled = self.isEnabled
        }

    }

#endif
